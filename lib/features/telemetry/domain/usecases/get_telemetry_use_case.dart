import 'package:mower_bot/features/telemetry/data/repositories/telemetry_repository_impl.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class GetTelemetryUseCase {
  final TelemetryRepository repository;

  GetTelemetryUseCase(this.repository);

  Stream<TelemetryEntity> call(Uri wsUrl) => repository.getTelemetryStream(wsUrl);
}