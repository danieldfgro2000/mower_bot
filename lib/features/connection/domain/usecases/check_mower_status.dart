import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class CheckMowerStatusUseCase {
  final MowerConnectionRepository _connectionRepository;

  CheckMowerStatusUseCase(this._connectionRepository);

  Future<bool> call() async => _connectionRepository.isConnected;
}
