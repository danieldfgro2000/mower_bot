import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';

void main() {
  group('TelemetryEvent', () {
    test('StartTelemetry and StopTelemetry have empty props', () {
      expect(StartTelemetry().props, isEmpty);
      expect(StopTelemetry().props, isEmpty);
    });

    test('TelemetryReceived includes telemetry in props', () {
      const t = TelemetryDataModel(
        wheelAngle: 1,
        opticalAngle: 2,
        distanceTraveled: 3,
        speed: 4,
        actuatorDrive: true,
        actuatorStart: false,
      );

      final e = TelemetryReceived(t);
      expect(e.props, [t]);
    });

    test('MegaTelemetryStatusUpdated includes all fields in props', () {
      final e = MegaTelemetryStatusUpdated(received: true, ageMs: 10, ok: false);
      expect(e.props, [true, 10, false]);
    });
  });
}

