import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/get_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';


class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final GetTelemetryUseCase telemetryStream;
  StreamSubscription<TelemetryEntity>? _subscription;

  TelemetryBloc(this.telemetryStream) : super(TelemetryInitial()) {
    on<StartTelemetry>(_onStartTelemetry);
    on<TelemetryReceived>(_onTelemetryReceived);
    on<StopTelemetry>(_onStopTelemetry);
  }

  void _onStartTelemetry(StartTelemetry event, Emitter<TelemetryState> emit) {
    emit(TelemetryLoading());
    _subscription = telemetryStream().listen(
      (telemetryData) => add(TelemetryReceived(telemetryData)),
      onError: (e) => emit(TelemetryError(e.toString())),
    );
  }

  void _onStopTelemetry(StopTelemetry event, Emitter<TelemetryState> emit) {
    _subscription?.cancel();
    emit(TelemetryInitial());
  }

  void _onTelemetryReceived(TelemetryReceived event, Emitter<TelemetryState> emit) {
    emit(TelemetryLoaded(event.telemetry));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
