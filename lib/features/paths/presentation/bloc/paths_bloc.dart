import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/stop_path.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_event.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_state.dart';

class PathBloc extends Bloc<PathEvent, PathState> {
  final GetPathsUseCase getPaths;
  final PlayPathUseCase playPath;
  final StopPathUseCase stopPath;
  final DeletePathUseCase deletePath;

  PathBloc(this.getPaths, this.playPath, this.stopPath, this.deletePath)
    : super(PathInitial()) {
    on<FetchPaths>((event, emit) async {
      emit(PathLoading());
      final paths = await getPaths();
      emit(PathLoaded(paths, activePath: null));
    });

    on<PlayPath>((event, emit) async {
      final current = state;
      if (current is! PathLoaded) return;
      final result = await playPath(event.name);
      if (emit.isDone) return;
      emit(
        _submissionState(
          current,
          result,
          submittedMessage: 'Playback submitted; awaiting mower confirmation.',
          failureMessage: 'Playback command was not submitted.',
        ),
      );
    });

    on<StopPath>((event, emit) async {
      final current = state;
      if (current is! PathLoaded) return;
      final result = await stopPath(event.name);
      if (emit.isDone) return;
      emit(
        _submissionState(
          current,
          result,
          submittedMessage: 'Stop submitted; awaiting mower confirmation.',
          failureMessage: 'Stop command was not submitted.',
        ),
      );
    });

    on<DeletePath>((event, emit) async {
      final current = state;
      if (current is! PathLoaded) return;
      final result = await deletePath(event.name);
      if (emit.isDone) return;
      emit(
        _submissionState(
          current,
          result,
          submittedMessage:
              'Delete submitted; refresh after mower confirmation.',
          failureMessage: 'Delete command was not submitted.',
        ),
      );
    });

    on<PathsReceived>((event, emit) {
      emit(PathLoaded(event.paths, activePath: null));
    });
  }

  PathLoaded _submissionState(
    PathLoaded current,
    CommandSubmissionResult result, {
    required String submittedMessage,
    required String failureMessage,
  }) {
    final errorMessage = switch (result) {
      CommandSubmissionResult.submitted => null,
      CommandSubmissionResult.disconnected =>
        '$failureMessage Control connection is unavailable.',
      CommandSubmissionResult.invalid =>
        '$failureMessage The path name is invalid.',
      CommandSubmissionResult.unknown => '$failureMessage Delivery is unknown.',
    };
    return PathLoaded(
      current.paths,
      activePath: current.activePath,
      commandMessage: result == CommandSubmissionResult.submitted
          ? submittedMessage
          : null,
      errorMessage: errorMessage,
    );
  }
}
