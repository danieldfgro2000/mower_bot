import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/paths/domain/usecases/save_path.dart';

import 'recording_state.dart';

class RecordingCubit extends Cubit<RecordingState> {
  final SavePathUseCase savePath;

  RecordingCubit(this.savePath) : super(const RecordingState());

  Future<void> startRecording() async {
    if (state.status != RecordingStatus.idle) return;

    emit(
      state.copyWith(
        status: RecordingStatus.submittingStart,
        clearErrorMessage: true,
        clearCommandMessage: true,
        clearLastSavedName: true,
      ),
    );
    late final CommandSubmissionResult result;
    try {
      result = await savePath.startRecording();
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: RecordingStatus.idle,
            errorMessage:
                'Could not start recording because of an unexpected error.',
            clearCommandMessage: true,
          ),
        );
      }
      return;
    }
    if (isClosed) return;

    if (result == CommandSubmissionResult.submitted) {
      emit(
        state.copyWith(
          status: RecordingStatus.recordingRequested,
          commandMessage:
              'Recording command submitted; awaiting device status.',
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: RecordingStatus.idle,
        errorMessage: _failureMessage('start', result),
        clearCommandMessage: true,
      ),
    );
  }

  Future<void> saveRecording(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a path name.'));
      return;
    }
    await _stopRecording(name: trimmedName, discard: false);
  }

  Future<void> discardRecording() => _stopRecording(name: '', discard: true);

  Future<void> _stopRecording({
    required String name,
    required bool discard,
  }) async {
    if (state.status != RecordingStatus.recordingRequested) return;

    emit(
      state.copyWith(
        status: RecordingStatus.submittingStop,
        clearErrorMessage: true,
        clearCommandMessage: true,
      ),
    );
    late final CommandSubmissionResult result;
    try {
      result = discard
          ? await savePath.discardRecording()
          : await savePath.saveRecording(name);
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: RecordingStatus.recordingRequested,
            errorMessage:
                'Could not ${discard ? 'discard' : 'save'} recording '
                'because of an unexpected error.',
            clearCommandMessage: true,
          ),
        );
      }
      return;
    }
    if (isClosed) return;

    if (result == CommandSubmissionResult.submitted) {
      emit(
        state.copyWith(
          status: RecordingStatus.idle,
          commandMessage: discard
              ? 'Discard command submitted; awaiting device status.'
              : 'Save command submitted; awaiting device status.',
          lastSavedName: discard ? null : name,
          clearLastSavedName: discard,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: RecordingStatus.recordingRequested,
        errorMessage: _failureMessage(discard ? 'discard' : 'save', result),
        clearCommandMessage: true,
      ),
    );
  }

  String _failureMessage(String operation, CommandSubmissionResult result) {
    return switch (result) {
      CommandSubmissionResult.disconnected =>
        'Could not $operation recording: control connection is unavailable.',
      CommandSubmissionResult.invalid =>
        'Could not $operation recording: the command is invalid.',
      CommandSubmissionResult.unknown =>
        'Could not $operation recording: delivery is unknown.',
      CommandSubmissionResult.submitted => '',
    };
  }
}
