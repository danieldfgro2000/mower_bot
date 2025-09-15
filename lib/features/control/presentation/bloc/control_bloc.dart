import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:stream_transform/stream_transform.dart' as st;

import 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final SendDriveCommandUseCase sendCommand;
  final GetVideoStreamUrlUseCase getVideoStreamUrl;
  final ObserverTelemetryUseCase observeTelemetryUseCase;

  StreamSubscription? _telemetrySubscription;

  EventTransformer<SteerCommand> debounceSteer() =>
    (events, mapper) => events
        .debounce(Duration(milliseconds: 100))
        .switchMap(mapper);

  ControlBloc(this.sendCommand, this.getVideoStreamUrl, this.observeTelemetryUseCase)
    : super(ControlState().initial()) {
    on<StartTelemetryStream>(_onStartTelemetryStream);
    on<TelemetryDataReceived>(_onTelemetryDataReceived);
    on<GetVideoStreamUrl>(_onGetVideoStreamUrl);
    on<DriveCommand>(_onDriveCommand);
    on<RunCommand>(_onRunCommand);
    on<SteerCommand>(_onSteerCommand, transformer: debounceSteer());
    on<StartRecord>(_onStartRecord);
    on<StopRecord>(_onStopRecord);
    on<EmergencyStop>(_onEmergencyStop);
    on<ClearError>(_onClearError);
  }

  FutureOr<void> _onStartTelemetryStream(event, emit) {
    print('Starting telemetry stream...');
    _telemetrySubscription?.cancel();
    _telemetrySubscription =
    observeTelemetryUseCase().listen(
      (telemetryData) => add(TelemetryDataReceived(telemetryData)),
      onError: (e) => emit(state.copyWith(errorMessage: e.toString())),
    );
  }

  FutureOr<void> _onTelemetryDataReceived(event, emit) {
    print('Telemetry data received: ${event.telemetryData}');
    final telemetryData = event.telemetryData;
    emit(state.copyWith(telemetryData: telemetryData));
    if (telemetryData.actuatorDrive == false) {
      emit(state.copyWith(isMowerMoving: false));
    }
  }

  FutureOr<void> _onGetVideoStreamUrl(event, emit) =>
      emit(state.copyWith(videoStreamUrl: getVideoStreamUrl()));

  FutureOr<void> _onDriveCommand(event, emit) async {
    final wasSent = await sendCommand({
      "mega": {
        "command": "drive",
        "isMoving": event.isMoving
      }
    });
    wasSent
      ? emit(state.copyWith(isMowerMoving: event.isMoving, errorMessage: ''))
      : emit(state.copyWith(errorMessage: "Failed to send drive command(Disconnected)"));
  }

  FutureOr<void> _onRunCommand(event, emit) async {
    final wasSent = await sendCommand({
      "mega": {
        "command": "start",
        "start": event.isRunning
      }
    });
    wasSent
      ? emit(state.copyWith(isMowerRunning: event.isRunning, errorMessage: ''))
      : emit(state.copyWith(errorMessage: "Failed to send run command(Disconnected)"));
  }

  FutureOr<void> _onSteerCommand(event, emit) async{
    final wasSent = await sendCommand({
      "mega": {
        "command": "steer",
        "angle": event.angle
      }
    });

    wasSent
      ? emit(state.copyWith(errorMessage: ''))
      : emit(state.copyWith(errorMessage: "Failed to send steer command"));
  }

  FutureOr<void> _onStartRecord(event, emit) async {
    final wasSent = await sendCommand({"cmd": "start_record"});
    wasSent
      ? emit(state.copyWith(isRecording: true, recordedFilePath: null))
      : emit(state.copyWith(errorMessage: "Failed to start recording (Disconnected)"));
  }

  FutureOr<void> _onStopRecord(event, emit) async {
    final wasSent = await sendCommand({"cmd": "stop_record", "fileName": event.fileName});
    wasSent
      ? emit(state.copyWith(isRecording: false, recordedFilePath: event.fileName))
      : emit(state.copyWith(errorMessage: "Failed to stop recording(Disconnected)"));
  }

  FutureOr<void> _onEmergencyStop(event, emit) async {
    final wasSent = await sendCommand({
      "mega": {
        "command": "emergency_stop"
      }
    });

    wasSent
      ? emit(state.copyWith(isMowerMoving: false, isMowerRunning: false))
      : emit(state.copyWith(errorMessage: "Failed to send emergency stop command (Disconnected)"));
  }

  FutureOr<void> _onClearError(event, emit) =>
      emit(state.copyWith(errorMessage: ''));

  @override
  Future<void> close() {
    _telemetrySubscription?.cancel();
    return super.close();
  }
}
