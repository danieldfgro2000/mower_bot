import 'package:mower_bot/core/device/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

abstract class TelemetryRepository {
  Future<void> startTelemetry();
  Future<void> stopTelemetry();
  Future<void> dispose();
  Stream<TelemetryDataModel> observeTelemetry();
  Stream<MowerStatusModel> observeMowerStatus();
  bool get isConnected;
}
