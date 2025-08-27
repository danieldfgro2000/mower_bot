import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class DisconnectCtrlWsUseCase {
  final MowerConnectionRepository _connectionRepository;

  DisconnectCtrlWsUseCase(this._connectionRepository);

  Future<void> call() async {
    await _connectionRepository.disconnectCtrlWs();
  }
}