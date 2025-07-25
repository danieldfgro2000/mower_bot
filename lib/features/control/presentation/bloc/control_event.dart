abstract class ControlEvent {}

class DriveCommand extends ControlEvent {
  final double steering;
  final bool isMoving;

  DriveCommand({
    required this.steering,
    required this.isMoving,
  });
}

class StartRecord extends ControlEvent {}

class StopRecord extends ControlEvent {
  final String fileName;

  StopRecord({
    required this.fileName,
  });
}

class EmergencyStop extends ControlEvent {}