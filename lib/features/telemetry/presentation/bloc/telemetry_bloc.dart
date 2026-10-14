import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/device/model/mower_status_model.dart';
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
    on<TelemetryStreamFailed>(_onTelemetryStreamFailed);
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
      onError: (error) => _addStreamError(
        TelemetryStreamSource.telemetry,
        'Telemetry data stream',
        error,
      ),
    );
    _observeTelemetryStatusSubscription = _observeTelemetryStatusUseCase()
        .listen(
          (status) => add(
            MegaTelemetryStatusUpdated(
              received: status.telemetryAge.received,
              ageMs: status.telemetryAge.ageMs,
              ok: status.telemetryAge.ok,
            ),
          ),
          onError: (error) => _addStreamError(
            TelemetryStreamSource.status,
            'Telemetry status stream',
            error,
          ),
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
    final current = _activeState;
    emit(
      TelemetryActive(
        telemetry: event.telemetry,
        received: current?.received,
        ageMs: current?.ageMs,
        ok: current?.ok,
        statusError: current?.statusError,
      ),
    );
  }

  void _onTelemetryStreamFailed(
    TelemetryStreamFailed event,
    Emitter<TelemetryState> emit,
  ) {
    final current = _activeState;
    emit(
      TelemetryActive(
        telemetry: current?.telemetry,
        received: current?.received,
        ageMs: current?.ageMs,
        ok: current?.ok,
        telemetryError: event.source == TelemetryStreamSource.telemetry
            ? event.error
            : current?.telemetryError,
        statusError: event.source == TelemetryStreamSource.status
            ? event.error
            : current?.statusError,
      ),
    );
  }

  void _addStreamError(
    TelemetryStreamSource stream,
    String source,
    Object error,
  ) {
    if (isClosed) return;
    add(TelemetryStreamFailed('$source: $error', source: stream));
  }

  void _onMegaTelemetryStatusUpdated(
    MegaTelemetryStatusUpdated event,
    Emitter<TelemetryState> emit,
  ) {
    final current = _activeState;
    emit(
      TelemetryActive(
        telemetry: current?.telemetry,
        received: event.received,
        ageMs: event.ageMs,
        ok: event.ok,
        telemetryError: current?.telemetryError,
      ),
    );
  }

  TelemetryActive? get _activeState =>
      state is TelemetryActive ? state as TelemetryActive : null;

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
