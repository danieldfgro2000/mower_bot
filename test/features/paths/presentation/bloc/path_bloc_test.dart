import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
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
      'PlayPath submission preserves activePath and shows pending feedback',
      build: () {
        when(
          () => playPath(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: null),
      act: (bloc) => bloc.add(PlayPath('b')),
      expect: () => [
        isA<PathLoaded>()
            .having((s) => s.paths, 'paths', ['a', 'b'])
            .having((s) => s.activePath, 'activePath', isNull)
            .having(
              (s) => s.commandMessage,
              'commandMessage',
              contains('awaiting mower confirmation'),
            ),
      ],
      verify: (_) => verify(() => playPath('b')).called(1),
    );

    blocTest<PathBloc, PathState>(
      'StopPath submission preserves activePath and shows pending feedback',
      build: () {
        when(
          () => stopPath(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: 'b'),
      act: (bloc) => bloc.add(StopPath('b')),
      expect: () => [
        isA<PathLoaded>()
            .having((s) => s.activePath, 'activePath', 'b')
            .having(
              (s) => s.commandMessage,
              'commandMessage',
              contains('awaiting mower confirmation'),
            ),
      ],
      verify: (_) => verify(() => stopPath('b')).called(1),
    );

    blocTest<PathBloc, PathState>(
      'PlayPath submission does not claim confirmed playback',
      build: () {
        when(
          () => playPath(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.disconnected);
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: null),
      act: (bloc) => bloc.add(PlayPath('b')),
      expect: () => [
        isA<PathLoaded>()
            .having((state) => state.activePath, 'activePath', isNull)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              contains('connection is unavailable'),
            ),
      ],
    );

    blocTest<PathBloc, PathState>(
      'StopPath submission preserves active playback until confirmation',
      build: () {
        when(
          () => stopPath(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.unknown);
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: 'b'),
      act: (bloc) => bloc.add(StopPath('b')),
      expect: () => [
        isA<PathLoaded>()
            .having((state) => state.activePath, 'activePath', 'b')
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              contains('Delivery is unknown'),
            ),
      ],
    );

    blocTest<PathBloc, PathState>(
      'DeletePath submission preserves list until mower confirmation',
      build: () {
        when(
          () => deletePath(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
        return PathBloc(getPaths, playPath, stopPath, deletePath);
      },
      seed: () => PathLoaded(['a', 'b'], activePath: 'b'),
      act: (bloc) => bloc.add(DeletePath('b')),
      expect: () => [
        isA<PathLoaded>()
            .having((s) => s.paths, 'paths', ['a', 'b'])
            .having((s) => s.activePath, 'activePath', 'b')
            .having(
              (s) => s.commandMessage,
              'commandMessage',
              contains('Delete submitted'),
            ),
      ],
      verify: (_) {
        verify(() => deletePath('b')).called(1);
        verifyNever(() => getPaths());
      },
    );
  });
}
