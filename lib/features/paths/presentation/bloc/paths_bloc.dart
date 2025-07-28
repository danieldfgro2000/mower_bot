import 'package:flutter_bloc/flutter_bloc.dart';
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

  PathBloc(
    this.getPaths,
    this.playPath,
    this.stopPath,
    this.deletePath,
  ) : super(PathInitial()) {
    on<FetchPaths>((event, emit) async {
      emit(PathLoading());
      final paths = await getPaths();
      emit(PathLoaded(paths, activePath: null));
    });

    on<PlayPath>((event, emit) async {
      await playPath(event.name);
      if (state is PathLoaded) {
        emit(PathLoaded((state as PathLoaded).paths, activePath: event.name));
      }
    });

    on<StopPath>((event, emit) async {
      await stopPath(event.name);
      if (state is PathLoaded) {
        final paths = (state as PathLoaded).paths;
        emit(PathLoaded(paths, activePath: null));
      }
    });

    on<DeletePath>((event, emit) async {
      emit(PathLoading());
      await deletePath(event.name);
      final paths = await getPaths();
      String? activePath;
      if(state is PathLoaded){
        activePath = (state as PathLoaded).activePath == event.name
          ? null
          : (state as PathLoaded).activePath;
      }
      emit(PathLoaded(paths, activePath: activePath));
    });

    on<PathsReceived>((event, emit) {
      emit(PathLoaded(event.paths, activePath: null));
    });

  }
}
