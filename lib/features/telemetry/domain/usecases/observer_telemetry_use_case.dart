import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class ObserverTelemetryUseCase {
  final TelemetryRepository _repository;
  ObserverTelemetryUseCase(this._repository);

  Stream<TelemetryEntity> call() {
    return _repository.observeTelemetry();
  }
}