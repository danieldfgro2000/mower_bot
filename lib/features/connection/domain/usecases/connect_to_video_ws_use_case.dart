import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class ConnectToVideoWsUseCase {
  final MowerConnectionRepository repository;

  ConnectToVideoWsUseCase(this.repository);

  Future<void> call(String ipAddress) async => repository.connectVideoWs(ipAddress);
}