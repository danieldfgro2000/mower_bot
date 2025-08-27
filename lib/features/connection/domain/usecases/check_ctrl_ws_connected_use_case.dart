import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class CheckCtrlWsConnectedUseCase {
  final MowerConnectionRepository _connectionRepository;

  CheckCtrlWsConnectedUseCase(this._connectionRepository);

  bool call() => _connectionRepository.isCtrlWsConnected;
}
