
import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

class ControlState extends Equatable {
  final bool? isConnected;
  final bool? isRecording;
  final bool? isVideoEnabled;
  final bool? isMowerMoving;
  final bool? isMowerRunning;
  final String? videoStreamUrl;
  final String? recordedFilePath;
  final String? errorMessage;
  final TelemetryDataModel? telemetryData;

  const ControlState({
    this.isConnected,
    this.isRecording,
    this.isVideoEnabled,
    this.isMowerMoving,
    this.isMowerRunning,
    this.videoStreamUrl,
    this.recordedFilePath,
    this.errorMessage,
    this.telemetryData,
  });

  ControlState initial() {
    return const ControlState(
      isConnected: false,
      isRecording: false,
      isVideoEnabled: false,
      isMowerMoving: false,
      isMowerRunning: false,
      videoStreamUrl: null,
      recordedFilePath: null,
      errorMessage: null,
      telemetryData: null
    );
  }

  @override
  List<Object?> get props => [
    isConnected,
    isRecording,
    isVideoEnabled,
    isMowerMoving,
    isMowerRunning,
    videoStreamUrl,
    recordedFilePath,
    errorMessage,
    telemetryData
  ];

  ControlState copyWith({
    bool? isConnected,
    bool? isRecording,
    bool? isVideoEnabled,
    bool? isVideoWsConnected,
    bool? isMowerMoving,
    bool? isMowerRunning,
    String? videoStreamUrl,
    String? recordedFilePath,
    String? errorMessage,
    TelemetryDataModel? telemetryData,
  }) {
    return ControlState(
      isConnected: isConnected ?? this.isConnected,
      isRecording: isRecording ?? this.isRecording,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isMowerMoving: isMowerMoving ?? this.isMowerMoving,
      isMowerRunning: isMowerRunning ?? this.isMowerRunning,
      videoStreamUrl: videoStreamUrl ?? this.videoStreamUrl,
      recordedFilePath: recordedFilePath ?? this.recordedFilePath,
      errorMessage: errorMessage ?? this.errorMessage,
      telemetryData: telemetryData ?? this.telemetryData,
    );
  }
}
