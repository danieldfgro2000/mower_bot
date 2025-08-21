import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class StartTelemetryStreamUseCase {
  final TelemetryRepository _telemetryRepository;

  StartTelemetryStreamUseCase(this._telemetryRepository);

  Future<void> call() async {
    await _telemetryRepository.startTelemetry();
  }
}