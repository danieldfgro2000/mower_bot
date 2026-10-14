import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';

import 'control_state.dart';

class _SubmitSteerCommand extends ControlEvent {
  final double angle;
  final int generation;

  const _SubmitSteerCommand({required this.angle, required this.generation});
}

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final SendDriveCommandUseCase sendCommand;
  final ObserverTelemetryUseCase observeTelemetryUseCase;

  StreamSubscription? _telemetrySubscription;
  Timer? _steerTimer;
  int _steerGeneration = 0;

  ControlBloc(this.sendCommand, this.observeTelemetryUseCase)
    : super(ControlState().initial()) {
    on<StartTelemetryStream>(_onStartTelemetryStream);
    on<TelemetryDataReceived>(_onTelemetryDataReceived);
    on<DriveCommand>(_onDriveCommand);
    on<RunCommand>(_onRunCommand);
    on<SteerCommand>(_onSteerRequested);
    on<_SubmitSteerCommand>(_onSteerCommand);
    on<EmergencyStop>(_onEmergencyStop);
    on<ClearError>(_onClearError);
  }

  FutureOr<void> _onStartTelemetryStream(event, emit) {
    _telemetrySubscription?.cancel();
    _telemetrySubscription = observeTelemetryUseCase().listen((telemetryData) {
      add(TelemetryDataReceived(telemetryData));
    }, onError: (e) => emit(state.copyWith(errorMessage: e.toString())));
  }

  FutureOr<void> _onTelemetryDataReceived(event, emit) {
    final telemetryData = event.telemetryData;
    emit(
      state.copyWith(
        telemetryData: telemetryData,
        isMowerMoving: telemetryData.actuatorDrive,
        isMowerRunning: telemetryData.actuatorStart,
      ),
    );
  }

  FutureOr<void> _onDriveCommand(event, emit) async {
    if (!event.isMoving) _invalidatePendingSteer();
    final result = await sendCommand({
      "mega": {"command": "drive", "isMoving": event.isMoving},
    });
    _emitSubmissionResult(
      emit,
      result,
      submittedMessage:
          'Drive command submitted; awaiting telemetry confirmation.',
      failureMessage: 'Drive command was not submitted.',
    );
  }

  FutureOr<void> _onRunCommand(event, emit) async {
    if (!event.isRunning) _invalidatePendingSteer();
    final result = await sendCommand({
      "mega": {"command": "start", "start": event.isRunning},
    });
    _emitSubmissionResult(
      emit,
      result,
      submittedMessage:
          'Run command submitted; awaiting telemetry confirmation.',
      failureMessage: 'Run command was not submitted.',
    );
  }

  void _onSteerRequested(SteerCommand event, Emitter<ControlState> emit) {
    emit(state.copyWith(commandedSteeringAngle: event.angle));
    _steerTimer?.cancel();
    final generation = ++_steerGeneration;
    _steerTimer = Timer(const Duration(milliseconds: 100), () {
      if (isClosed || generation != _steerGeneration) return;
      add(_SubmitSteerCommand(angle: event.angle, generation: generation));
    });
  }

  FutureOr<void> _onSteerCommand(
    _SubmitSteerCommand event,
    Emitter<ControlState> emit,
  ) async {
    if (event.generation != _steerGeneration) return;
    _steerTimer = null;
    final result = await sendCommand({
      "mega": {"command": "steer", "angle": event.angle},
    });

    _emitSubmissionResult(
      emit,
      result,
      submittedMessage: 'Steering command submitted.',
      failureMessage: 'Steering command was not submitted.',
    );
  }

  FutureOr<void> _onEmergencyStop(event, emit) async {
    _invalidatePendingSteer();
    final result = await sendCommand({
      "mega": {"command": "emergency_stop"},
    });

    _emitSubmissionResult(
      emit,
      result,
      submittedMessage:
          'Emergency stop submitted; awaiting telemetry confirmation.',
      failureMessage: 'Emergency stop was not submitted.',
    );
  }

  void _invalidatePendingSteer() {
    _steerGeneration++;
    _steerTimer?.cancel();
    _steerTimer = null;
  }

  void _emitSubmissionResult(
    Emitter<ControlState> emit,
    CommandSubmissionResult result, {
    required String submittedMessage,
    required String failureMessage,
  }) {
    switch (result) {
      case CommandSubmissionResult.submitted:
        emit(
          state.copyWith(errorMessage: '', commandMessage: submittedMessage),
        );
      case CommandSubmissionResult.disconnected:
        emit(
          state.copyWith(
            errorMessage: '$failureMessage Control connection is unavailable.',
            commandMessage: '',
          ),
        );
      case CommandSubmissionResult.invalid:
        emit(
          state.copyWith(
            errorMessage: '$failureMessage The command is invalid.',
            commandMessage: '',
          ),
        );
      case CommandSubmissionResult.unknown:
        emit(
          state.copyWith(
            errorMessage: '$failureMessage Delivery is unknown.',
            commandMessage: '',
          ),
        );
    }
  }

  FutureOr<void> _onClearError(event, emit) =>
      emit(state.copyWith(errorMessage: ''));

  @override
  Future<void> close() {
    _invalidatePendingSteer();
    _telemetrySubscription?.cancel();
    return super.close();
  }
}
