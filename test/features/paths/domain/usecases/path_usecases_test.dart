import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/repo/path_repository_impl.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
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
      when(() => repo.playPath(any())).thenAnswer((_) async {});

      final uc = PlayPathUseCase(repo);
      await uc('x');

      verify(() => repo.playPath('x')).called(1);
    });

    test('StopPathUseCase delegates to repository.stopPath', () async {
      when(() => repo.stopPath(any())).thenAnswer((_) async {});

      final uc = StopPathUseCase(repo);
      await uc('x');

      verify(() => repo.stopPath('x')).called(1);
    });

    test('DeletePathUseCase delegates to repository.deletePath', () async {
      when(() => repo.deletePath(any())).thenAnswer((_) async {});

      final uc = DeletePathUseCase(repo);
      await uc('x');

      verify(() => repo.deletePath('x')).called(1);
    });
  });
}

