
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

class TelemetryDataDTO {
  final double stepperAngle;
  final double angleFromOptical;
  final double distanceTraveled;
  final double speed;
  final bool actuatorDrive;
  final bool actuatorStart;

  const TelemetryDataDTO({
    required this.stepperAngle,
    required this.angleFromOptical,
    required this.distanceTraveled,
    required this.speed,
    required this.actuatorDrive,
    required this.actuatorStart,
  });

  factory TelemetryDataDTO.fromJson(Map<String, dynamic> json) {
    return TelemetryDataDTO(
      stepperAngle: (json['stepperAngle'] as num?)?.toDouble() ?? 0.0,
      angleFromOptical: (json['actualAngleFromOptic'] as num?)?.toDouble() ?? 0.0,
      distanceTraveled: (json['distanceTraveled'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      actuatorDrive: json['actuatorDrive'] ?? false,
      actuatorStart: json['actuatorStart'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepperAngle': stepperAngle,
      'actualAngleFromOptic': angleFromOptical,
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
      wheelAngle: toD(data['angle']),
      speed: toD(data['speed']),
      distanceTraveled: toD(data['distance']),
      actuatorDrive: data['actuatorDrive'] ?? false,
      actuatorStart: data['actuatorStart'] ?? false,
    );
  }
}
