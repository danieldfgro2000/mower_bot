import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';


class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final StartTelemetryStreamUseCase _startTelemetryStreamUseCase;
  final ObserverTelemetryUseCase _observeTelemetryStreamUseCase;
  StreamSubscription<TelemetryEntity>? _observeTelemetrySubscription;

  TelemetryBloc(this._startTelemetryStreamUseCase, this._observeTelemetryStreamUseCase) : super(TelemetryInitial()) {
    on<StartTelemetry>(_onStartTelemetry);
    on<TelemetryReceived>(_onTelemetryReceived);
    on<StopTelemetry>(_onStopTelemetry);
  }

  void _onStartTelemetry(StartTelemetry event, Emitter<TelemetryState> emit) {
    emit(TelemetryLoading());
    _startTelemetryStreamUseCase.call();
    _observeTelemetrySubscription = _observeTelemetryStreamUseCase().listen(
      (telemetryData) => add(TelemetryReceived(telemetryData)),
      onError: (e) => TelemetryError(e.toString()),
    );
  }

  void _onStopTelemetry(StopTelemetry event, Emitter<TelemetryState> emit) {
    _observeTelemetrySubscription?.cancel();
    emit(TelemetryInitial());
  }

  void _onTelemetryReceived(TelemetryReceived event, Emitter<TelemetryState> emit) {
    emit(TelemetryLoaded(event.telemetry));
  }

  @override
  Future<void> close() {
    _observeTelemetrySubscription?.cancel();
    return super.close();
  }
}
