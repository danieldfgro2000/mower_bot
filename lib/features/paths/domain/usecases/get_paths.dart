import 'package:mower_bot/core/data/repo/path_repository_impl.dart';

class GetPathsUseCase {
  final PathRepository repository;

  GetPathsUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.fetchPaths();
  }
}