import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class CheckVideoWsConnectedUseCase {
  final MowerConnectionRepository repository;

  CheckVideoWsConnectedUseCase(this.repository);

  bool call() => repository.isVideoWsConnected;
}