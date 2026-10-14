import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/control/presentation/bloc/recording_cubit.dart';
import 'package:mower_bot/features/control/presentation/bloc/recording_state.dart';
import 'package:mower_bot/features/paths/domain/usecases/save_path.dart';

class _MockSavePathUseCase extends Mock implements SavePathUseCase {}

void main() {
  group('RecordingCubit', () {
    late _MockSavePathUseCase savePath;

    setUp(() {
      savePath = _MockSavePathUseCase();
    });

    blocTest<RecordingCubit, RecordingState>(
      'reports a disconnected start without claiming recording',
      setUp: () {
        when(
          () => savePath.startRecording(),
        ).thenAnswer((_) async => CommandSubmissionResult.disconnected);
      },
      build: () => RecordingCubit(savePath),
      act: (cubit) => cubit.startRecording(),
      expect: () => [
        isA<RecordingState>().having(
          (state) => state.status,
          'status',
          RecordingStatus.submittingStart,
        ),
        isA<RecordingState>()
            .having((state) => state.status, 'status', RecordingStatus.idle)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              contains('unavailable'),
            ),
      ],
    );

    blocTest<RecordingCubit, RecordingState>(
      'submitted start is represented as a request awaiting device status',
      setUp: () {
        when(
          () => savePath.startRecording(),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      },
      build: () => RecordingCubit(savePath),
      act: (cubit) => cubit.startRecording(),
      expect: () => [
        isA<RecordingState>().having(
          (state) => state.status,
          'status',
          RecordingStatus.submittingStart,
        ),
        isA<RecordingState>()
            .having(
              (state) => state.status,
              'status',
              RecordingStatus.recordingRequested,
            )
            .having(
              (state) => state.commandMessage,
              'commandMessage',
              contains('awaiting device status'),
            ),
      ],
    );

    test('discard submits an empty-name stop and returns to idle', () async {
      when(
        () => savePath.startRecording(),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      when(
        () => savePath.discardRecording(),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      final cubit = RecordingCubit(savePath);
      addTearDown(cubit.close);

      await cubit.startRecording();
      await cubit.discardRecording();

      verify(() => savePath.discardRecording()).called(1);
      expect(cubit.state.status, RecordingStatus.idle);
      expect(cubit.state.lastSavedName, isNull);
    });

    test('failed save keeps the recording request active', () async {
      when(
        () => savePath.startRecording(),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      when(
        () => savePath.saveRecording('yard'),
      ).thenAnswer((_) async => CommandSubmissionResult.disconnected);
      final cubit = RecordingCubit(savePath);
      addTearDown(cubit.close);

      await cubit.startRecording();
      await cubit.saveRecording('yard');

      expect(cubit.state.status, RecordingStatus.recordingRequested);
      expect(cubit.state.errorMessage, contains('unavailable'));
    });

    test('empty save name is rejected without submitting a stop', () async {
      when(
        () => savePath.startRecording(),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      final cubit = RecordingCubit(savePath);
      addTearDown(cubit.close);

      await cubit.startRecording();
      await cubit.saveRecording('  ');

      expect(cubit.state.status, RecordingStatus.recordingRequested);
      expect(cubit.state.errorMessage, 'Enter a path name.');
      verifyNever(() => savePath.saveRecording(any()));
    });

    test(
      'unexpected start failure is visible and does not stay pending',
      () async {
        when(() => savePath.startRecording()).thenThrow(StateError('failed'));
        final cubit = RecordingCubit(savePath);
        addTearDown(cubit.close);

        await cubit.startRecording();

        expect(cubit.state.status, RecordingStatus.idle);
        expect(cubit.state.errorMessage, contains('unexpected error'));
      },
    );
  });
}
