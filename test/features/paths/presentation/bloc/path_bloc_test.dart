import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/stop_path.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_event.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_state.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';

class _MockGetPathsUseCase extends Mock implements GetPathsUseCase {}
class _MockPlayPathUseCase extends Mock implements PlayPathUseCase {}
class _MockStopPathUseCase extends Mock implements StopPathUseCase {}
class _MockDeletePathUseCase extends Mock implements DeletePathUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PathBloc', () {
    late _MockGetPathsUseCase getPaths;
    late _MockPlayPathUseCase playPath;
    late _MockStopPathUseCase stopPath;
    late _MockDeletePathUseCase deletePath;

    setUp(() {
      getPaths = _MockGetPathsUseCase();
      playPath = _MockPlayPathUseCase();
      stopPath = _MockStopPathUseCase();
      deletePath = _MockDeletePathUseCase();
    });

    blocTest<PathBloc, PathState>(
      'FetchPaths emits loading then loaded with paths',
      build: () {
        when(() => getPaths()).thenAnswer((_) async => ['a', 'b']);
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      act: (bloc) => bloc.add(FetchPaths()),
      expect: () => [
        isA<PathLoading>(),
        isA<PathLoaded>()
            .having((s) => s.paths, 'paths', ['a', 'b'])
            .having((s) => s.activePath, 'activePath', isNull),
      ],
    );

    blocTest<PathBloc, PathState>(
      'PlayPath sets activePath when already loaded',
      build: () {
        when(() => playPath(any())).thenAnswer((_) async {});
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: null),
      act: (bloc) => bloc.add(PlayPath('b')),
      expect: () => [
        isA<PathLoaded>()
            .having((s) => s.paths, 'paths', ['a', 'b'])
            .having((s) => s.activePath, 'activePath', 'b'),
      ],
      verify: (_) => verify(() => playPath('b')).called(1),
    );

    blocTest<PathBloc, PathState>(
      'StopPath clears activePath when already loaded',
      build: () {
        when(() => stopPath(any())).thenAnswer((_) async {});
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: 'b'),
      act: (bloc) => bloc.add(StopPath('b')),
      expect: () => [
        isA<PathLoaded>()
            .having((s) => s.activePath, 'activePath', isNull),
      ],
      verify: (_) => verify(() => stopPath('b')).called(1),
    );

    blocTest<PathBloc, PathState>(
      'DeletePath reloads and clears activePath if deleted was active',
      build: () {
        when(() => deletePath(any())).thenAnswer((_) async {});
        when(() => getPaths()).thenAnswer((_) async => ['a']);
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: 'b'),
      act: (bloc) => bloc.add(DeletePath('b')),
      expect: () => [
        isA<PathLoading>(),
        isA<PathLoaded>()
            .having((s) => s.paths, 'paths', ['a'])
            .having((s) => s.activePath, 'activePath', isNull),
      ],
      verify: (_) {
        verify(() => deletePath('b')).called(1);
        verify(() => getPaths()).called(1);
      },
    );
  });
}

