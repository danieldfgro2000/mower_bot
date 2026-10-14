import 'package:mower_bot/core/device/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class ObserverTelemetryStatusUseCase {
  final TelemetryRepository _repository;
  ObserverTelemetryStatusUseCase(this._repository);

  Stream<MowerStatusModel> call() {
    return _repository.observeMowerStatus();
  }
}
