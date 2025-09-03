import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class SendDriveCommandUseCase {
  final ControlRepository repository;

  SendDriveCommandUseCase(this.repository);

  Future<void> call(Map<String, dynamic> command) async {
    await repository.sendDriveCommand(command);
  }
}