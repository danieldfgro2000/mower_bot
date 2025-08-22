import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ControlState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ControlStateInitial extends ControlState {}

class ControlStateStatus extends ControlState {
  final bool? isConnected;
  final bool? isRecording;
  final bool? isStreaming;
  final String? recordedFilePath;
  final String? errorMessage;
  final Stream<Uint8List> videoFrames;

  ControlStateStatus({
    this.isConnected,
    this.isRecording,
    this.isStreaming,
    this.recordedFilePath,
    this.errorMessage,
    required this.videoFrames,
  });

  @override
  List<Object?> get props => [
        isConnected,
        isRecording,
        isStreaming,
        recordedFilePath,
        errorMessage,
        videoFrames,
      ];
}