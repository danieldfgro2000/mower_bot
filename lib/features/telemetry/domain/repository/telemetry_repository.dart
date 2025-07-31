import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

abstract class TelemetryRepository {
  Stream<TelemetryEntity> getTelemetryStream();
}