import 'package:mower_bot/core/data/dto/telemetry_age_dto.dart';
import 'package:mower_bot/core/data/dto/wifi_info_dto.dart';
import 'package:mower_bot/core/data/dto/ws_info_dto.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/connection/domain/model/wifi_info_model.dart';

class MowerStatusDTO {
  final int uptimeMs;
  final WiFiInfoDTO wifi;
  final WsInfoDTO ws;
  final TelemetryAgeDTO telemetryAge;

  const MowerStatusDTO({
    required this.uptimeMs,
    required this.wifi,
    required this.ws,
    required this.telemetryAge,
  });

  factory MowerStatusDTO.fromJson(Map<String, dynamic> json) {
    return MowerStatusDTO(
      uptimeMs: json['uptimeMs'] ?? 0,
      wifi: WiFiInfoDTO.fromJson(json['wifi'] ?? const {}),
      ws: WsInfoDTO.fromJson(json['ws'] ?? const {}),
      telemetryAge: TelemetryAgeDTO.fromJson(json['telemetry'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uptimeMs': uptimeMs,
      'wifi': wifi.toJson(),
      'ws': ws.toJson(),
      'telemetry': telemetryAge.toJson(),
    };
  }
  
}

extension MowerStatusDTOx on MowerStatusDTO {
  MowerStatusModel toDomain() => MowerStatusModel(
    uptimeMs: uptimeMs,
    wifi: wifi.toDomain(),
    ws: ws.toDomain(),
    telemetryAge: telemetryAge.toDomain(),
  );
}

class MowerStatusMapper {
  static MowerStatusModel fromData(Map<String, dynamic> data) {
    return MowerStatusModel(
      uptimeMs: data['uptimeMs'] ?? 0,
      wifi: data['wifi'] ?? const {},
      ws: data['ws'] ?? const {},
      telemetryAge: data['telemetry'] ?? const {},
    );
  }
}