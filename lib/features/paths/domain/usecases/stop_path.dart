import 'package:mower_bot/features/paths/data/repositories/path_repository_impl.dart';

class StopPathUseCase {
  final PathRepository repository;
  StopPathUseCase(this.repository);

  Future<void> call(String name) async => await repository.stopPath(name);
}