


class TelemetryEntity {
  final double wheelAngle;
  final double distanceTraveled;
  final double speed;
  final bool actuatorDrive;
  final bool actuatorStart;

  const TelemetryEntity({
    required this.wheelAngle,
    required this.distanceTraveled,
    required this.speed,
    required this.actuatorDrive,
    required this.actuatorStart,
  });

  factory TelemetryEntity.fromJson(Map<String, dynamic> json) {
    return TelemetryEntity(
      wheelAngle: (json['wheelAngle'] as num?)?.toDouble() ?? 0.0,
      distanceTraveled: (json['distanceTraveled'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      actuatorDrive: json['actuatorDrive'] ?? false,
      actuatorStart: json['actuatorStart'] ?? false,
    );
  }

}