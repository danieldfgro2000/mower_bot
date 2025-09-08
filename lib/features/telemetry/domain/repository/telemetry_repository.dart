
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

abstract class TelemetryRepository {
  Future<void> startTelemetry();
  Stream<TelemetryDataModel> observeTelemetry();
  Stream<MowerStatusModel> observeMowerStatus();
  bool get isConnected;
}