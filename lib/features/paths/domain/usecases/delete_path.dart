import 'package:mower_bot/features/paths/data/repositories/path_repository_impl.dart';

class DeletePathUseCase {
  final PathRepository repository;

  DeletePathUseCase(this.repository);

  Future<void> call(String pathId) async {
    await repository.deletePath(pathId);
  }
}