import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ControlState extends Equatable {
  final bool? isConnected;
  final bool? isRecording;
  final bool? isStreaming;
  final bool? isVideoWsConnected;
  final String? recordedFilePath;
  final String? errorMessage;
  final Stream<Uint8List>? videoFrames;
  final String? mjpegUrl;
  final bool? isVideoEnabled;

  const ControlState({
    this.isConnected,
    this.isRecording,
    this.isStreaming,
    this.isVideoWsConnected,
    this.recordedFilePath,
    this.errorMessage,
    this.videoFrames,
    this.mjpegUrl,
    this.isVideoEnabled,
  });

  ControlState initial() {
    return const ControlState(
      isConnected: false,
      isRecording: false,
      isStreaming: false,
      isVideoWsConnected: false,
      recordedFilePath: null,
      errorMessage: null,
      videoFrames: null,
        mjpegUrl: 'http://172.20.10.12:8080/?action=stream',
      isVideoEnabled: false,
    );
  }

  @override
  List<Object?> get props => [
    isConnected,
    isRecording,
    isStreaming,
    isVideoWsConnected,
    recordedFilePath,
    errorMessage,
    videoFrames,
    mjpegUrl,
    isVideoEnabled,
  ];

  ControlState copyWith({
    bool? isConnected,
    bool? isRecording,
    bool? isStreaming,
    bool? isVideoWsConnected,
    String? recordedFilePath,
    String? errorMessage,
    Stream<Uint8List>? videoFrames,
    String? mjpegUrl,
    bool? isVideoEnabled,
  }) {
    return ControlState(
      isConnected: isConnected ?? this.isConnected,
      isRecording: isRecording ?? this.isRecording,
      isStreaming: isStreaming ?? this.isStreaming,
      isVideoWsConnected: isVideoWsConnected ?? this.isVideoWsConnected,
      recordedFilePath: recordedFilePath ?? this.recordedFilePath,
      errorMessage: errorMessage ?? this.errorMessage,
      videoFrames: videoFrames ?? this.videoFrames,
      mjpegUrl: mjpegUrl ?? this.mjpegUrl,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
    );
  }
}
