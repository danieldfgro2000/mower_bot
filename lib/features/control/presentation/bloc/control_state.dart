import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ControlState extends Equatable {
  final bool? isConnected;
  final bool? isRecording;
  final bool? isVideoEnabled;
  final bool? isVideoWsConnected;
  final String? videoStreamUrl;
  final String? recordedFilePath;
  final String? errorMessage;

  const ControlState({
    this.isConnected,
    this.isRecording,
    this.isVideoEnabled,
    this.isVideoWsConnected,
    this.videoStreamUrl,
    this.recordedFilePath,
    this.errorMessage,
  });

  ControlState initial() {
    return const ControlState(
      isConnected: false,
      isRecording: false,
      isVideoEnabled: false,
      isVideoWsConnected: false,
      videoStreamUrl: null,
      recordedFilePath: null,
      errorMessage: null,
    );
  }

  @override
  List<Object?> get props => [
    isConnected,
    isRecording,
    isVideoEnabled,
    isVideoWsConnected,
    videoStreamUrl,
    recordedFilePath,
    errorMessage,
  ];

  ControlState copyWith({
    bool? isConnected,
    bool? isRecording,
    bool? isVideoEnabled,
    bool? isVideoWsConnected,
    String? videoStreamUrl,
    String? recordedFilePath,
    String? errorMessage,
  }) {
    return ControlState(
      isConnected: isConnected ?? this.isConnected,
      isRecording: isRecording ?? this.isRecording,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isVideoWsConnected: isVideoWsConnected ?? this.isVideoWsConnected,
      videoStreamUrl: videoStreamUrl ?? this.videoStreamUrl,
      recordedFilePath: recordedFilePath ?? this.recordedFilePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
