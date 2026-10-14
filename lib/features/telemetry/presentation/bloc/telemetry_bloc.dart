import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/stop_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';

class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final StartTelemetryStreamUseCase _startTelemetryStreamUseCase;
  final StopTelemetryStreamUseCase _stopTelemetryStreamUseCase;
  final ObserverTelemetryUseCase _observeTelemetryStreamUseCase;
  final ObserverTelemetryStatusUseCase _observeTelemetryStatusUseCase;
  StreamSubscription<TelemetryDataModel>? _observeTelemetrySubscription;
  StreamSubscription<MowerStatusModel>? _observeTelemetryStatusSubscription;
  bool _streamStarted = false;

  TelemetryBloc(
    this._startTelemetryStreamUseCase,
    this._stopTelemetryStreamUseCase,
    this._observeTelemetryStreamUseCase,
    this._observeTelemetryStatusUseCase,
  ) : super(TelemetryInitial()) {
    on<TelemetryLifecycleEvent>(_onLifecycleEvent, transformer: sequential());
    on<TelemetryReceived>(_onTelemetryReceived);
    on<MegaTelemetryStatusUpdated>(_onMegaTelemetryStatusUpdated);
  }

  Future<void> _onLifecycleEvent(
    TelemetryLifecycleEvent event,
    Emitter<TelemetryState> emit,
  ) {
    if (event is StartTelemetry) return _onStartTelemetry(event, emit);
    if (event is StopTelemetry) return _onStopTelemetry(event, emit);
    return Future<void>.value();
  }

  Future<void> _onStartTelemetry(
    StartTelemetry event,
    Emitter<TelemetryState> emit,
  ) async {
    if (_streamStarted) return;
    emit(TelemetryLoading());
    try {
      await _startTelemetryStreamUseCase();
    } catch (error) {
      emit(TelemetryError(error.toString()));
      return;
    }
    _streamStarted = true;
    _observeTelemetrySubscription = _observeTelemetryStreamUseCase().listen(
      (telemetryData) => add(TelemetryReceived(telemetryData)),
      onError: (e) => TelemetryError(e.toString()),
    );
    _observeTelemetryStatusSubscription = _observeTelemetryStatusUseCase()
        .listen(
          (status) => add(
            MegaTelemetryStatusUpdated(
              received: status.telemetryAge.received,
              ageMs: (status.telemetryAge.ageMs ?? -1) > 0
                  ? (status.telemetryAge.ageMs! / 60000).toInt()
                  : -1,
              ok: status.telemetryAge.ok,
            ),
          ),
          onError: (e) => TelemetryError(e.toString()),
        );
  }

  Future<void> _onStopTelemetry(
    StopTelemetry event,
    Emitter<TelemetryState> emit,
  ) async {
    await _stopRepositoryStream();
    await _cancelObservationSubscriptions();
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

  Future<void> _stopRepositoryStream() async {
    if (!_streamStarted) return;
    await _stopTelemetryStreamUseCase();
    _streamStarted = false;
  }

  Future<void> _cancelObservationSubscriptions() async {
    await _observeTelemetrySubscription?.cancel();
    _observeTelemetrySubscription = null;
    await _observeTelemetryStatusSubscription?.cancel();
    _observeTelemetryStatusSubscription = null;
  }

  @override
  Future<void> close() async {
    await _stopRepositoryStream();
    await _cancelObservationSubscriptions();
    return super.close();
  }
}
