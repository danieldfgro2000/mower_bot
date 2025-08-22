import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

abstract class TelemetryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TelemetryInitial extends TelemetryState {}

class TelemetryLoading extends TelemetryState {}

class TelemetryLoaded extends TelemetryState {
  final TelemetryEntity telemetry;

  TelemetryLoaded(this.telemetry);

  @override
  List<Object?> get props => [telemetry];
}

class TelemetryError extends TelemetryState {
  final String error;

  TelemetryError(this.error);

  @override
  List<Object?> get props => [error];
}

class MegaTelemetryStatus extends TelemetryState {
  final bool received;
  final int ageMs;
  final bool ok;

  MegaTelemetryStatus({
    required this.received,
    required this.ageMs,
    required this.ok,
  });

  @override
  List<Object?> get props => [received, ageMs, ok];
}