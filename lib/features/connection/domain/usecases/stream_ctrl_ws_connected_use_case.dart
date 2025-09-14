import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class StreamCtrlWsConnectedUseCase {
  final MowerConnectionRepository _connectionRepository;

  StreamCtrlWsConnectedUseCase(this._connectionRepository);

  Stream<bool>? call() {
    return _connectionRepository.ctrlWsConnected();
  }
}