import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class DisconnectMowerUseCase {
  final MowerConnectionRepository _connectionRepository;

  DisconnectMowerUseCase(this._connectionRepository);

  Future<void> call() async {
    await _connectionRepository.disconnect();
  }
}