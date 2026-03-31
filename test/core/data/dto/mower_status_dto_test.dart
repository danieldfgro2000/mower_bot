import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/dto/mower_status_dto.dart';
import 'package:mower_bot/core/data/dto/telemetry_age_dto.dart';
import 'package:mower_bot/core/data/dto/wifi_info_dto.dart';
import 'package:mower_bot/core/data/dto/ws_info_dto.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/connection/domain/model/telemetry_age_model.dart';
import 'package:mower_bot/features/connection/domain/model/wifi_info_model.dart';
import 'package:mower_bot/features/connection/domain/model/ws_info_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MowerStatusDTO', () {
    test('fromJson uses defaults', () {
      final dto = MowerStatusDTO.fromJson({});
      expect(dto.uptimeMs, 0);
      expect(dto.wifi.connected, isFalse);
      expect(dto.ws.clients, 0);
      expect(dto.telemetryAge.received, isFalse);
    });

    test('toJson round-trip', () {
      const dto = MowerStatusDTO(
        uptimeMs: 10,
        wifi: WiFiInfoDTO(connected: true, ip: '10.0.0.2'),
        ws: WsInfoDTO(clients: 3),
        telemetryAge: TelemetryAgeDTO(received: true, ageMs: 100, ok: true),
      );

      expect(dto.toJson(), {
        'uptimeMs': 10,
        'wifi': {'connected': true, 'ip': '10.0.0.2'},
        'ws': {'clients': 3},
        'telemetry': {'received': true, 'ageMs': 100, 'ok': true},
      });

      final back = MowerStatusDTO.fromJson(dto.toJson());
      expect(back.uptimeMs, 10);
      expect(back.wifi.connected, isTrue);
      expect(back.wifi.ip, '10.0.0.2');
      expect(back.ws.clients, 3);
      expect(back.telemetryAge.ageMs, 100);
    });

    test('toDomain maps to MowerStatusModel', () {
      const dto = MowerStatusDTO(
        uptimeMs: 1,
        wifi: WiFiInfoDTO(connected: false, ip: ''),
        ws: WsInfoDTO(clients: 1),
        telemetryAge: TelemetryAgeDTO(received: true, ageMs: null, ok: false),
      );

      expect(
        dto.toDomain(),
        const MowerStatusModel(
          uptimeMs: 1,
          wifi: WiFiInfoModel(connected: false, ip: ''),
          ws: WsInfoModel(clients: 1),
          telemetryAge: TelemetryAgeModel(received: true, ageMs: null, ok: false),
        ),
      );
    });
  });

  group('MowerStatusMapper', () {
    test('fromData maps nested DTOs with defaults', () {
      final out = MowerStatusMapper.fromData({
        'uptimeMs': 5,
        'wifi': {'connected': true, 'ip': 'x'},
        'ws': {'clients': 2},
        'telemetry': {'received': false, 'ageMs': 7, 'ok': true},
      });

      expect(
        out,
        const MowerStatusModel(
          uptimeMs: 5,
          wifi: WiFiInfoModel(connected: true, ip: 'x'),
          ws: WsInfoModel(clients: 2),
          telemetryAge: TelemetryAgeModel(received: false, ageMs: 7, ok: true),
        ),
      );
    });
  });
}

