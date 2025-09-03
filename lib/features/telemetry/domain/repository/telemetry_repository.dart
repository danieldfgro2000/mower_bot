import 'package:mower_bot/features/connection/domain/entity/mower_status_entity.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

abstract class TelemetryRepository {
  Future<void> startTelemetry();
  Stream<TelemetryEntity> observeTelemetry();
  Stream<MowerStatusEntity> observeTelemetryStatus();
  bool get isConnected;
}