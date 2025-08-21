import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

abstract class TelemetryRepository {
  Future<void> startTelemetry();
  Stream<TelemetryEntity> observeTelemetry();
  bool get isConnected;
}