import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/dto/telemetry_age_dto.dart';
import 'package:mower_bot/features/connection/domain/model/telemetry_age_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TelemetryAgeDTO', () {
    test('fromJson uses defaults', () {
      final dto = TelemetryAgeDTO.fromJson({});
      expect(dto.received, isFalse);
      expect(dto.ageMs, isNull);
      expect(dto.ok, isFalse);
    });

    test('toJson round-trip', () {
      const dto = TelemetryAgeDTO(received: true, ageMs: 123, ok: true);
      expect(dto.toJson(), {'received': true, 'ageMs': 123, 'ok': true});

      final back = TelemetryAgeDTO.fromJson(dto.toJson());
      expect(back.received, isTrue);
      expect(back.ageMs, 123);
      expect(back.ok, isTrue);
    });

    test('toDomain maps to TelemetryAgeModel', () {
      const dto = TelemetryAgeDTO(received: true, ageMs: 5, ok: false);
      expect(dto.toDomain(), const TelemetryAgeModel(received: true, ageMs: 5, ok: false));
    });

    test('toString includes keys', () {
      const dto = TelemetryAgeDTO(received: false, ageMs: null, ok: true);
      final s = dto.toString();
      expect(s, contains('TelemetryAgeDTO'));
      expect(s, contains('received'));
      expect(s, contains('ageMs'));
      expect(s, contains('ok'));
    });
  });
}

