import 'package:mower_bot/features/connection/domain/entity/mower_status_entity.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class ObserverTelemetryStatusUseCase {
  final TelemetryRepository _repository;
  ObserverTelemetryStatusUseCase(this._repository);

  Stream<MowerStatusEntity> call() {
    return _repository.observeTelemetryStatus();
  }
}