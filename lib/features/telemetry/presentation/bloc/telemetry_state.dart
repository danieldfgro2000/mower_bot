import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/core/diffable_state.dart';

abstract class TelemetryState extends Equatable implements DiffableState {
  // Provide a minimal diff map including the runtime type so type transitions are visible
  @override
  Map<String, dynamic> toDiffMap() => {'_type': runtimeType.toString()};

  @override
  List<Object?> get props => [];
}

class TelemetryInitial extends TelemetryState {}

class TelemetryLoading extends TelemetryState {}

class TelemetryLoaded extends TelemetryState {
  final TelemetryDataModel telemetry;

  TelemetryLoaded(this.telemetry);

  @override
  List<Object?> get props => [telemetry];

  @override
  Map<String, dynamic> toDiffMap() => {
        ...super.toDiffMap(),
        'wheelAngle': telemetry.wheelAngle,
        'opticalAngle': telemetry.opticalAngle,
        'distanceTraveled': telemetry.distanceTraveled,
        'speed': telemetry.speed,
        'actuatorDrive': telemetry.actuatorDrive,
        'actuatorStart': telemetry.actuatorStart,
      };
}

class TelemetryError extends TelemetryState {
  final String error;

  TelemetryError(this.error);

  @override
  List<Object?> get props => [error];

  @override
  Map<String, dynamic> toDiffMap() => {
        ...super.toDiffMap(),
        'error': error,
      };
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

  @override
  Map<String, dynamic> toDiffMap() => {
        ...super.toDiffMap(),
        'received': received,
        'ageMs': ageMs,
        'ok': ok,
      };
}