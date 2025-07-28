import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class ConnectToMowerUseCase {
  final MowerConnectionRepository repository;
  ConnectToMowerUseCase(this.repository);

  Future<void> call(String ipAddress, int port) async {
    return repository.connect(ipAddress, port);
  }
}