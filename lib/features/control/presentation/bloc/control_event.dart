
import 'package:equatable/equatable.dart';

abstract class ControlEvent extends Equatable {
  const ControlEvent();

  @override
  List<Object?> get props => [];
}

class CheckConnectionStatus extends ControlEvent {}

class GetVideoStreamUrl extends ControlEvent {}

class DriveCommand extends ControlEvent {
  final bool isMoving;

  const DriveCommand({
    required this.isMoving,
  });

  @override
  List<Object?> get props => [isMoving];
}

class RunCommand extends ControlEvent {
  final bool isRunning;

  const RunCommand({
    required this.isRunning,
  });

  @override
  List<Object?> get props => [isRunning];
}

class SteerCommand extends ControlEvent {
  final double angle;

  const SteerCommand({
    required this.angle,
  });

  @override
  List<Object?> get props => [angle];
}

class StartRecord extends ControlEvent {}

class StopRecord extends ControlEvent {
  final String fileName;

  const StopRecord({
    required this.fileName,
  });
}

class EmergencyStop extends ControlEvent {}

class ClearError extends ControlEvent {}