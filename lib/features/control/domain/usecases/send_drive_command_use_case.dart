import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class SendDriveCommandUseCase {
  final ControlRepository repository;

  SendDriveCommandUseCase(this.repository);

  Future<CommandSubmissionResult> call(Map<String, dynamic> command) =>
      repository.sendDriveCommand(command);
}
