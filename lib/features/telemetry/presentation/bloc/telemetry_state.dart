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

class TelemetryError extends TelemetryState {
  final String error;

  TelemetryError(this.error);

  @override
  List<Object?> get props => [error];

  @override
  Map<String, dynamic> toDiffMap() => {...super.toDiffMap(), 'error': error};
}

class TelemetryActive extends TelemetryState {
  final TelemetryDataModel? telemetry;
  final bool? received;
  final int? ageMs;
  final bool? ok;
  final String? telemetryError;
  final String? statusError;

  TelemetryActive({
    this.telemetry,
    this.received,
    this.ageMs,
    this.ok,
    this.telemetryError,
    this.statusError,
  });

  String? get error {
    final errors = [telemetryError, statusError].whereType<String>().toList();
    return errors.isEmpty ? null : errors.join('\n');
  }

  @override
  List<Object?> get props => [
    telemetry,
    received,
    ageMs,
    ok,
    telemetryError,
    statusError,
  ];

  @override
  Map<String, dynamic> toDiffMap() => {
    ...super.toDiffMap(),
    if (telemetry != null) ...{
      'wheelAngle': telemetry!.wheelAngle,
      'opticalAngle': telemetry!.opticalAngle,
      'distanceTraveled': telemetry!.distanceTraveled,
      'speed': telemetry!.speed,
      'actuatorDrive': telemetry!.actuatorDrive,
      'actuatorStart': telemetry!.actuatorStart,
    },
    'received': received,
    'ageMs': ageMs,
    'ok': ok,
    'error': error,
  };
}
