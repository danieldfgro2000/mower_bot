import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/telemetry/data/datasources/telemetry_remote_datasource.dart';
import 'package:mower_bot/features/telemetry/data/models/telemetry_model.dart';

class ObserverTelemetryUseCase {
  final TelemetryRemoteDataSource _repository;
  ObserverTelemetryUseCase(this._repository);

  Stream<TelemetryModel> call() {
    return _repository.observeTelemetry();
  }
}