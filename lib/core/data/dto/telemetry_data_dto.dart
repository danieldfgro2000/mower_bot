
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

class TelemetryDataDTO {
  final double wheelAngle;
  final double distanceTraveled;
  final double speed;
  final bool actuatorDrive;
  final bool actuatorStart;

  const TelemetryDataDTO({
    required this.wheelAngle,
    required this.distanceTraveled,
    required this.speed,
    required this.actuatorDrive,
    required this.actuatorStart,
  });

  factory TelemetryDataDTO.fromJson(Map<String, dynamic> json) {
    return TelemetryDataDTO(
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
  static TelemetryDataModel fromData(Map<String, dynamic> data) {
    double toD(dynamic v) => (v is num) ? v.toDouble() : 0.0;
    return TelemetryDataModel(
      wheelAngle: toD(data['wheelAngle']),
      distanceTraveled: toD(data['distanceTraveled']),
      speed: toD(data['speed']),
      actuatorDrive: data['actuatorDrive'] ?? false,
      actuatorStart: data['actuatorStart'] ?? false,
    );
  }
}
