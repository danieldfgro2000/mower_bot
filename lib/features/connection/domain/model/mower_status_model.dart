import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/connection/domain/model/telemetry_age_model.dart';
import 'package:mower_bot/features/connection/domain/model/wifi_info_model.dart';
import 'package:mower_bot/features/connection/domain/model/ws_info_model.dart';

class MowerStatusModel extends Equatable {
  final int uptimeMs;
  final WiFiInfoModel wifi;
  final WsInfoModel ws;
  final TelemetryAgeModel telemetryAge;

  const MowerStatusModel({
    required this.uptimeMs,
    required this.wifi,
    required this.ws,
    required this.telemetryAge,
  });

  @override
  List<Object?> get props => [uptimeMs, wifi, ws, telemetryAge];
}