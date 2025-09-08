
import 'package:equatable/equatable.dart';

class TelemetryDataModel extends Equatable{
  final double wheelAngle;
  final double distanceTraveled;
  final double speed;
  final bool actuatorDrive;
  final bool actuatorStart;

  const TelemetryDataModel({
    required this.wheelAngle,
    required this.distanceTraveled,
    required this.speed,
    required this.actuatorDrive,
    required this.actuatorStart,
  });

  @override
  List<Object?> get props => [
    wheelAngle,
    distanceTraveled,
    speed,
    actuatorDrive,
    actuatorStart,
  ];
}