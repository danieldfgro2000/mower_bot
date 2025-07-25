

import 'dart:math';

class TelemetryEntity {
  final double battery;
  final double heading;
  final double encoderSpeed;
  final bool isMoving;
  final double driftX;
  final double driftY;
  final double headingError;

  const TelemetryEntity({
    required this.battery,
    required this.heading,
    required this.encoderSpeed,
    required this.isMoving,
    this.driftX = 0.0,
    this.driftY = 0.0,
    this.headingError = 0.0,
  });

  double get driftMagnitude => sqrt(driftX * driftX + driftY * driftY);
}