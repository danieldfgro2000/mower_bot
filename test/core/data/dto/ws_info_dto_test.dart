import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/dto/ws_info_dto.dart';
import 'package:mower_bot/features/connection/domain/model/ws_info_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WsInfoDTO', () {
    test('fromJson uses defaults', () {
      final dto = WsInfoDTO.fromJson({});
      expect(dto.clients, 0);
    });

    test('toJson round-trip', () {
      const dto = WsInfoDTO(clients: 2);
      expect(dto.toJson(), {'clients': 2});

      final back = WsInfoDTO.fromJson(dto.toJson());
      expect(back.clients, 2);
    });

    test('toDomain maps to WsInfoModel', () {
      const dto = WsInfoDTO(clients: 7);
      expect(dto.toDomain(), const WsInfoModel(clients: 7));
    });

    test('toString includes keys', () {
      const dto = WsInfoDTO(clients: 1);
      final s = dto.toString();
      expect(s, contains('WsInfoDTO'));
      expect(s, contains('clients'));
    });
  });
}

