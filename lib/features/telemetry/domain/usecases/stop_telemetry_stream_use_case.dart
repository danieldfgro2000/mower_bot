import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class StopTelemetryStreamUseCase {
  final TelemetryRepository _telemetryRepository;

  StopTelemetryStreamUseCase(this._telemetryRepository);

  Future<void> call() => _telemetryRepository.stopTelemetry();
}
