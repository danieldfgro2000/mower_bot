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
              heading: json['heading']?.toDouble() ?? 0.0,
              encoderSpeed: json['encoderSpeed']?.toDouble() ?? 0.0,
              isMoving: json['isMoving'] ?? false,
            ),
          ),
        );
      }
    });
  }
}
