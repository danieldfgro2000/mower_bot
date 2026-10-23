import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/paths/domain/repository/path_repository.dart';

class StopPathUseCase {
  final PathRepository repository;
  StopPathUseCase(this.repository);

  Future<CommandSubmissionResult> call(String name) =>
      repository.stopPath(name);
}
