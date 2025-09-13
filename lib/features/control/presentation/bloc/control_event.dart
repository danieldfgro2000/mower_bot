
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
}

class SteerCommand extends ControlEvent {
  final double angle;

  const SteerCommand({
    required this.angle,
  });
}

class StartRecord extends ControlEvent {}

class StopRecord extends ControlEvent {
  final String fileName;

  const StopRecord({
    required this.fileName,
  });
}

class EmergencyStop extends ControlEvent {}