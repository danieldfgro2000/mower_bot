import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class GetTelemetryUrlUseCase {
  final MowerConnectionRepository _repository;
  GetTelemetryUrlUseCase(this._repository);

  Future<Uri?> call() => _repository.getTelemetryUrl();
}