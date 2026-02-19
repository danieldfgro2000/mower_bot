import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/dto/wifi_info_dto.dart';
import 'package:mower_bot/features/connection/domain/model/wifi_info_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WiFiInfoDTO', () {
    test('fromJson uses defaults for missing fields', () {
      final dto = WiFiInfoDTO.fromJson({});
      expect(dto.connected, isFalse);
      expect(dto.ip, '');
    });

    test('toJson round-trip', () {
      const dto = WiFiInfoDTO(connected: true, ip: '10.0.0.2');
      expect(dto.toJson(), {'connected': true, 'ip': '10.0.0.2'});
      final back = WiFiInfoDTO.fromJson(dto.toJson());
      expect(back.connected, isTrue);
      expect(back.ip, '10.0.0.2');
    });

    test('toDomain maps into WiFiInfoModel', () {
      const dto = WiFiInfoDTO(connected: true, ip: '10.0.0.42');
      final domain = dto.toDomain();
      expect(domain, const WiFiInfoModel(connected: true, ip: '10.0.0.42'));
    });

    test('toString includes serialized keys', () {
      const dto = WiFiInfoDTO(connected: false, ip: '');
      final s = dto.toString();
      expect(s, contains('WiFiInfoDTO'));
      expect(s, contains('connected'));
      expect(s, contains('ip'));
    });
  });
}

