import 'package:mower_bot/features/telemetry/data/repositories/telemetry_repository_impl.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

class StreamTelemetryUseCase {
  final TelemetryRepository repository;

  StreamTelemetryUseCase(this.repository);

  Stream<TelemetryEntity> call() => repository.streamTelemetry();
}