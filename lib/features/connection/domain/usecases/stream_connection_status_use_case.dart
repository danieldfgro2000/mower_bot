import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/core/device/model/connection_status.dart';

class StreamConnectionStatusUseCase {
  final MowerConnectionRepository _connectionRepository;

  StreamConnectionStatusUseCase(this._connectionRepository);

  Stream<ConnectionStatus>? call() {
    return _connectionRepository.ctrlWsConnected();
  }
}
