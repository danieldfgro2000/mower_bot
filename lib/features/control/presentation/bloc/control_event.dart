import 'dart:typed_data';

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

class StartVideoStream extends ControlEvent {}

class StopVideoStream extends ControlEvent {}

class VideoFrameReceived extends ControlEvent {
  final Uint8List frame;

  VideoFrameReceived(this.frame);
}

class VideoStreamError extends ControlEvent {
  final String error;

  VideoStreamError(this.error);
}