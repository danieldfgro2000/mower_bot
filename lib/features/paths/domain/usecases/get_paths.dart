import 'package:mower_bot/features/paths/domain/repository/path_repository.dart';

class GetPathsUseCase {
  final PathRepository repository;

  GetPathsUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.fetchPaths();
  }
}
