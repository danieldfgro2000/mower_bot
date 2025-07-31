import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';

import '../../domain/entities/telemetry_entity.dart';

class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final Stream<Map<String, dynamic>> telemetryStream;

  TelemetryBloc(this.telemetryStream) : super(TelemetryInitial()) {
    telemetryStream.listen((data) {
      add(TelemetryReceived(data));
    });

    on<StartTelemetryStream>(
        (StartTelemetryStream event, Emitter<TelemetryState> emit) {
      // This event can be used to trigger the telemetry stream if needed.
      // Currently, the stream is already being listened to in the constructor.

    });

    on<TelemetryReceived>((event, emit) {
      final json = event.data;
      if (json['event'] == 'lap_completed') {
        emit(
          TelemetryDriftState(
            driftX: json['driftX'] ?? 0.0,
            driftY: json['driftY'] ?? 0.0,
            headingError: json['headingError'] ?? 0.0,
          ),
        );
      } else {
        emit(
          TelemetryDataState(
            TelemetryEntity(
              battery: json['battery']?.toDouble() ?? 0.0,
              angle: json['angle']?.toDouble() ?? 0.0,
              encoder: json['encoder']?.toDouble() ?? 0.0,
              drive: json['drive'] ?? false,
              start: json['start'] ?? false,
              distance: json['distance']?.toDouble() ?? 0.0,
              speed: json['speed']?.toDouble() ?? 0.0,
              homed: json['homed'] ?? false,
              driftX: json['driftX']?.toDouble() ?? 0.0,
              driftY: json['driftY']?.toDouble() ?? 0.0,
              headingError: json['headingError']?.toDouble() ?? 0.0,
            ),
          ),
        );
      }
    });
  }
}
