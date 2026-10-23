import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/paths/domain/repository/path_repository.dart';

class DeletePathUseCase {
  final PathRepository repository;

  DeletePathUseCase(this.repository);

  Future<CommandSubmissionResult> call(String pathId) =>
      repository.deletePath(pathId);
}
