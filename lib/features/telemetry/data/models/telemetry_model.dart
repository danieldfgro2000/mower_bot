import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

class TelemetryModel extends TelemetryEntity {
  TelemetryModel({
    required super.wheelAngle,
    required super.distanceTraveled,
    required super.speed,
    required super.actuatorDrive,
    required super.actuatorStart,
  });

  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      wheelAngle: (json['wheelAngle'] as num?)?.toDouble() ?? 0.0,
      distanceTraveled: (json['distanceTraveled'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      actuatorDrive: json['actuatorDrive'] ?? false,
      actuatorStart: json['actuatorStart'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'wheelAngle': wheelAngle,
      'distanceTraveled': distanceTraveled,
      'speed': speed,
      'actuatorDrive': actuatorDrive,
      'actuatorStart': actuatorStart,
    };
  }

  @override
  String toString() {
    return 'TelemetryModel${toJson()}';
  }
}