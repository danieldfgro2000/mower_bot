import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class ConnectToCtrlWsUseCase {
  final MowerConnectionRepository repository;
  ConnectToCtrlWsUseCase(this.repository);

  Future<void> call(String ipAddress) async {
    return repository.connectCtrlWs(ipAddress);
  }
}