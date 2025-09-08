import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class ObserverTelemetryUseCase {
  final TelemetryRepository _repository;
  ObserverTelemetryUseCase(this._repository);

  Stream<TelemetryDataModel> call() {
    return _repository.observeTelemetry();
  }
}