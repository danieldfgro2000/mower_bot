

import 'dart:math';

class TelemetryEntity {
  final double battery;
  final double angle;
  final double encoder;
  final bool drive;
  final bool start;
  final double distance;
  final double speed;
  final bool homed;
  final double driftX;
  final double driftY;
  final double headingError;

  const TelemetryEntity({
    required this.battery,
    required this.angle,
    required this.encoder,
    required this.drive,
    required this.start,
    required this.distance,
    required this.speed,
    required this.homed,
    this.driftX = 0.0,
    this.driftY = 0.0,
    this.headingError = 0.0,
  });

  factory TelemetryEntity.fromJson(Map<String, dynamic> json) {
    return TelemetryEntity(
      battery: (json['battery'] as num?)?.toDouble() ?? 0.0,
      angle: (json['angle'] as num?)?.toDouble() ?? 0.0,
      encoder: (json['encoder'] as num?)?.toDouble() ?? 0.0,
      drive: json['drive'] ?? false,
      start: json['start'] ?? false,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      homed: json['homed'] ?? false,
      driftX: (json['driftX'] as num?)?.toDouble() ?? 0.0,
      driftY: (json['driftY'] as num?)?.toDouble() ?? 0.0,
      headingError: (json['headingError'] as num?)?.toDouble() ?? 0.0,
    );
  }

  double get driftMagnitude => sqrt(driftX * driftX + driftY * driftY);
}

class TelemetryModel extends TelemetryEntity {
  const TelemetryModel({
    required super.battery,
    required super.angle,
    required super.encoder,
    required super.drive,
    required super.start,
    required super.distance,
    required super.speed,
    required super.homed,
    super.driftX,
    super.driftY,
    super.headingError,
  });

  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      battery: (json['battery'] as num?)?.toDouble() ?? 0.0,
      angle: (json['angle'] as num?)?.toDouble() ?? 0.0,
      encoder: (json['encoder'] as num?)?.toDouble() ?? 0.0,
      drive: json['drive'] ?? false,
      start: json['start'] ?? false,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      homed: json['homed'] ?? false,
      driftX: (json['driftX'] as num?)?.toDouble() ?? 0.0,
      driftY: (json['driftY'] as num?)?.toDouble() ?? 0.0,
      headingError: (json['headingError'] as num?)?.toDouble() ?? 0.0,
    );
  }
}