import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/paths/domain/repository/path_repository.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/save_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/stop_path.dart';
import 'package:mocktail/mocktail.dart';

class _MockPathRepository extends Mock implements PathRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Path usecases', () {
    late _MockPathRepository repo;

    setUp(() {
      repo = _MockPathRepository();
    });

    test('GetPathsUseCase delegates to repository.fetchPaths', () async {
      when(() => repo.fetchPaths()).thenAnswer((_) async => ['a', 'b']);

      final uc = GetPathsUseCase(repo);
      final out = await uc();

      expect(out, ['a', 'b']);
      verify(() => repo.fetchPaths()).called(1);
    });

    test('PlayPathUseCase delegates to repository.playPath', () async {
      when(
        () => repo.playPath(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);

      final uc = PlayPathUseCase(repo);
      expect(await uc('x'), CommandSubmissionResult.submitted);

      verify(() => repo.playPath('x')).called(1);
    });

    test('StopPathUseCase delegates to repository.stopPath', () async {
      when(
        () => repo.stopPath(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);

      final uc = StopPathUseCase(repo);
      expect(await uc('x'), CommandSubmissionResult.submitted);

      verify(() => repo.stopPath('x')).called(1);
    });

    test('DeletePathUseCase delegates to repository.deletePath', () async {
      when(
        () => repo.deletePath(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);

      final uc = DeletePathUseCase(repo);
      expect(await uc('x'), CommandSubmissionResult.submitted);

      verify(() => repo.deletePath('x')).called(1);
    });

    test('SavePathUseCase exposes start, save, and discard outcomes', () async {
      when(
        () => repo.startRecord(),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      when(
        () => repo.stopRecord(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      final useCase = SavePathUseCase(repo);

      expect(await useCase.startRecording(), CommandSubmissionResult.submitted);
      expect(
        await useCase.saveRecording('yard'),
        CommandSubmissionResult.submitted,
      );
      expect(
        await useCase.discardRecording(),
        CommandSubmissionResult.submitted,
      );

      verify(() => repo.startRecord()).called(1);
      verify(() => repo.stopRecord('yard')).called(1);
      verify(() => repo.stopRecord('')).called(1);
    });
  });
}
