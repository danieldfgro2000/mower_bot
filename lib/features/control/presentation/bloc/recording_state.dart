import 'package:equatable/equatable.dart';

enum RecordingStatus {
  idle,
  submittingStart,
  recordingRequested,
  submittingStop,
}

class RecordingState extends Equatable {
  final RecordingStatus status;
  final String? errorMessage;
  final String? commandMessage;
  final String? lastSavedName;

  const RecordingState({
    this.status = RecordingStatus.idle,
    this.errorMessage,
    this.commandMessage,
    this.lastSavedName,
  });

  bool get isRecordingRequested =>
      status == RecordingStatus.recordingRequested ||
      status == RecordingStatus.submittingStop;

  bool get isBusy =>
      status == RecordingStatus.submittingStart ||
      status == RecordingStatus.submittingStop;

  RecordingState copyWith({
    RecordingStatus? status,
    String? errorMessage,
    String? commandMessage,
    String? lastSavedName,
    bool clearErrorMessage = false,
    bool clearCommandMessage = false,
    bool clearLastSavedName = false,
  }) {
    return RecordingState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      commandMessage: clearCommandMessage
          ? null
          : commandMessage ?? this.commandMessage,
      lastSavedName: clearLastSavedName
          ? null
          : lastSavedName ?? this.lastSavedName,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    commandMessage,
    lastSavedName,
  ];
}
