import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class DisconnectVideoWsUseCase {
  final MowerConnectionRepository repository;

  DisconnectVideoWsUseCase(this.repository);

  Future<void> call() async {
    await repository.disconnectVideoWs();
  }
}