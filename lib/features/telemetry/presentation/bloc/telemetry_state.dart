import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

abstract class TelemetryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TelemetryInitial extends TelemetryState {}

class TelemetryDataState extends TelemetryState {
  final TelemetryEntity telemetry;
  final bool? loading;
  final String? error;

  TelemetryDataState(this.telemetry, {this.loading, this.error});

  @override
  List<Object?> get props => [telemetry, loading, error];
}

class TelemetryDriftState extends TelemetryState {
  final double driftX;
  final double driftY;
  final double headingError;

  TelemetryDriftState({
    required this.driftX,
    required this.driftY,
    required this.headingError,
  });

  @override
  List<Object?> get props => [driftX, driftY];
}
