


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
    return 'TelemetryEntity${toJson()}';
  }
}

class TelemetryMapper {
  static TelemetryEntity fromData(Map<String, dynamic> data) {
    double _toD(dynamic v) => (v is num) ? v.toDouble() : 0.0;
    return TelemetryEntity(
      wheelAngle: _toD(data['wheelAngle']),
      distanceTraveled: _toD(data['distanceTraveled']),
      speed: _toD(data['speed']),
      actuatorDrive: data['actuatorDrive'] ?? false,
      actuatorStart: data['actuatorStart'] ?? false,
    );
  }
}

