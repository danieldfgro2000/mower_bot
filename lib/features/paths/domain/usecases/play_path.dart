import 'package:mower_bot/core/data/repo/path_repository_impl.dart';

class PlayPathUseCase {
  final PathRepository repository;
  PlayPathUseCase(this.repository);

  Future<void> call(String name) async {
    await repository.playPath(name);
  }
}