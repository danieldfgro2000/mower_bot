import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class SendDriveCommandUseCase {
  final ControlRepository repository;

  SendDriveCommandUseCase(this.repository);

  Future<bool> call(Map<String, dynamic> command) async {
    if (repository.isCtrlWsConnected) await repository.sendDriveCommand(command);
    return repository.isCtrlWsConnected;
  }
}