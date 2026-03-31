import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/dto/telemetry_data_dto.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TelemetryDataDTO', () {
    test('fromJson parses numeric fields and defaults missing values', () {
      final dto = TelemetryDataDTO.fromJson({
        'stepperAngle': 1,
        'actualAngleFromOptic': 2.5,
        'distanceTraveled': null,
        // omit speed entirely to exercise default path without triggering a cast error
        'actuatorDrive': true,
      });

      expect(dto.stepperAngle, 1.0);
      expect(dto.angleFromOptical, 2.5);
      expect(dto.distanceTraveled, 0.0);
      expect(dto.speed, 0.0);
      expect(dto.actuatorDrive, isTrue);
      expect(dto.actuatorStart, isFalse);
    });

    test('toJson round-trip', () {
      const dto = TelemetryDataDTO(
        stepperAngle: 1,
        angleFromOptical: 2,
        distanceTraveled: 3,
        speed: 4,
        actuatorDrive: true,
        actuatorStart: false,
      );

      expect(dto.toJson(), {
        'stepperAngle': 1.0,
        'actualAngleFromOptic': 2.0,
        'distanceTraveled': 3.0,
        'speed': 4.0,
        'actuatorDrive': true,
        'actuatorStart': false,
      });

      final back = TelemetryDataDTO.fromJson(dto.toJson());
      expect(back.stepperAngle, 1.0);
      expect(back.angleFromOptical, 2.0);
      expect(back.distanceTraveled, 3.0);
      expect(back.speed, 4.0);
      expect(back.actuatorDrive, isTrue);
      expect(back.actuatorStart, isFalse);
    });

    test('toString includes serialized keys', () {
      const dto = TelemetryDataDTO(
        stepperAngle: 0,
        angleFromOptical: 0,
        distanceTraveled: 0,
        speed: 0,
        actuatorDrive: false,
        actuatorStart: false,
      );
      final s = dto.toString();
      expect(s, contains('TelemetryEntity'));
      expect(s, contains('stepperAngle'));
      expect(s, contains('actualAngleFromOptic'));
    });
  });

  group('TelemetryMapper', () {
    test('fromData converts num to double and defaults non-num to 0', () {
      final m = TelemetryMapper.fromData({
        'stepperAngle': 1,
        'actualAngleFromOptic': 2.5,
        'speed': null,
        'distanceTraveled': 'nope',
        'actuatorDrive': true,
        'actuatorStart': null,
      });

      expect(
        m,
        const TelemetryDataModel(
          wheelAngle: 1.0,
          opticalAngle: 2.5,
          distanceTraveled: 0.0,
          speed: 0.0,
          actuatorDrive: true,
          actuatorStart: false,
        ),
      );
    });
  });
}
