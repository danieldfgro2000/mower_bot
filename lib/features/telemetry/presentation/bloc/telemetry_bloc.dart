import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';

class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final StartTelemetryStreamUseCase _startTelemetryStreamUseCase;
  final ObserverTelemetryUseCase _observeTelemetryStreamUseCase;
  final ObserverTelemetryStatusUseCase _observeTelemetryStatusUseCase;
  StreamSubscription<TelemetryDataModel>? _observeTelemetrySubscription;
  StreamSubscription<MowerStatusModel>? _observeTelemetryStatusSubscription;

  TelemetryBloc(
    this._startTelemetryStreamUseCase,
    this._observeTelemetryStreamUseCase,
    this._observeTelemetryStatusUseCase,
  ) : super(TelemetryInitial()) {
    on<StartTelemetry>(_onStartTelemetry);
    on<TelemetryReceived>(_onTelemetryReceived);
    on<StopTelemetry>(_onStopTelemetry);
    on<MegaTelemetryStatusUpdated>(_onMegaTelemetryStatusUpdated);
  }

  void _onStartTelemetry(StartTelemetry event, Emitter<TelemetryState> emit) {
    emit(TelemetryLoading());
    _startTelemetryStreamUseCase.call().onError((error, stackTrace) {
      emit(TelemetryError(error.toString()));
    });
    _observeTelemetrySubscription = _observeTelemetryStreamUseCase().listen(
      (telemetryData) => add(TelemetryReceived(telemetryData)),
      onError: (e) => TelemetryError(e.toString()),
    );
    _observeTelemetryStatusSubscription = _observeTelemetryStatusUseCase().listen(
      (status) => add(
        MegaTelemetryStatusUpdated(
          received: status.telemetryAge.received,
          ageMs: (status.telemetryAge.ageMs  ?? -1) > 0
              ? (status.telemetryAge.ageMs! / 60000).toInt()
              : -1,
          ok: status.telemetryAge.ok,
        ),
      ),
      onError: (e) => TelemetryError(e.toString()),
    );
  }

  void _onStopTelemetry(StopTelemetry event, Emitter<TelemetryState> emit) {
    _observeTelemetrySubscription?.cancel();
    _observeTelemetryStatusSubscription?.cancel();
    emit(TelemetryInitial());
  }

  void _onTelemetryReceived(
    TelemetryReceived event,
    Emitter<TelemetryState> emit,
  ) {
    emit(TelemetryLoaded(event.telemetry));
  }

  void _onMegaTelemetryStatusUpdated(
    MegaTelemetryStatusUpdated event,
    Emitter<TelemetryState> emit,
  ) {
    emit(
      MegaTelemetryStatus(
        received: event.received,
        ageMs: event.ageMs,
        ok: event.ok,
      ),
    );
  }

  @override
  Future<void> close() {
    _observeTelemetrySubscription?.cancel();
    return super.close();
  }
}
