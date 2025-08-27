import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ControlEvent extends Equatable {
  const ControlEvent();

  @override
  List<Object?> get props => [];
}

class CheckConnectionStatus extends ControlEvent {}

class ConnectionChanged extends ControlEvent {
  final bool? isVideoWsConnected;

  const ConnectionChanged({this.isVideoWsConnected});

  @override
  List<Object?> get props => [isVideoWsConnected];
}

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

class VideoStreamError extends ControlEvent {
  final String error;

  VideoStreamError(this.error);
}