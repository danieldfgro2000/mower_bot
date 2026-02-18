import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/repo/telemetry_repository_impl.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

import '../../../test_helpers/fake_websocket_client.dart';

void main() {
  group('TelemetryRepositoryImpl', () {
    test('startTelemetry throws when websocket is not connected', () async {
      final ws = FakeWebSocketClient();
      final repo = TelemetryRepositoryImpl(ws);

      expect(repo.startTelemetry, throwsA(isA<Exception>()));
    });

    test('telemetry topic emits TelemetryDataModel with mapped fields', () async {
      final ws = FakeWebSocketClient();
      ws.emitConnection(ConnectionStatus.ctrlWsConnected);

      final repo = TelemetryRepositoryImpl(ws);
      await repo.startTelemetry();

      final future = expectLater(
        repo.observeTelemetry(),
        emits(
          isA<TelemetryDataModel>()
              .having((m) => m.wheelAngle, 'wheelAngle', 12.5)
              .having((m) => m.opticalAngle, 'opticalAngle', 9.0)
              .having((m) => m.speed, 'speed', 1.2)
              .having((m) => m.distanceTraveled, 'distanceTraveled', 3.4)
              .having((m) => m.actuatorDrive, 'actuatorDrive', true)
              .having((m) => m.actuatorStart, 'actuatorStart', false),
        ),
      );

      ws.emitMessage({
        'topic': 'telemetry',
        'data': {
          'stepperAngle': 12.5,
          'actualAngleFromOptic': 9,
          'speed': 1.2,
          'distanceTraveled': 3.4,
          'actuatorDrive': true,
          'actuatorStart': false,
        },
      });

      await future;
    });

    test('status topic emits MowerStatusModel and uses data.telemetry map (passthrough)', () async {
      final ws = FakeWebSocketClient();
      ws.emitConnection(ConnectionStatus.ctrlWsConnected);

      final repo = TelemetryRepositoryImpl(ws);
      await repo.startTelemetry();

      final future = expectLater(
        repo.observeMowerStatus(),
        emits(
          isA<MowerStatusModel>()
              .having((m) => m.uptimeMs, 'uptimeMs', 123)
              .having((m) => m.wifi.connected, 'wifi.connected', true)
              .having((m) => m.wifi.ip, 'wifi.ip', '192.168.4.2')
              .having((m) => m.ws.clients, 'ws.clients', 2)
              .having((m) => m.telemetryAge.received, 'telemetryAge.received', true)
              .having((m) => m.telemetryAge.ageMs, 'telemetryAge.ageMs', 42)
              .having((m) => m.telemetryAge.ok, 'telemetryAge.ok', true),
        ),
      );

      ws.emitMessage({
        'topic': 'status',
        'data': {
          // TelemetryRepositoryImpl reads envelope.data['telemetry'] and maps it as a full status payload.
          'telemetry': {
            'uptimeMs': 123,
            'wifi': {'connected': true, 'ip': '192.168.4.2'},
            'ws': {'clients': 2},
            'telemetry': {'received': true, 'ageMs': 42, 'ok': true},
          }
        },
      });

      await future;
    });

    test('telemetry continues streaming multiple telemetry messages', () async {
      final ws = FakeWebSocketClient();
      ws.emitConnection(ConnectionStatus.ctrlWsConnected);

      final repo = TelemetryRepositoryImpl(ws);
      await repo.startTelemetry();

      final future = expectLater(
        repo.observeTelemetry(),
        emitsInOrder([
          isA<TelemetryDataModel>().having((m) => m.wheelAngle, 'wheelAngle', 1.0),
          isA<TelemetryDataModel>().having((m) => m.wheelAngle, 'wheelAngle', 2.0),
        ]),
      );

      ws.emitMessage({
        'topic': 'telemetry',
        'data': {'stepperAngle': 1.0},
      });
      ws.emitMessage({
        'topic': 'telemetry',
        'data': {'stepperAngle': 2.0},
      });

      await future;
    });

    test('unknown topics are ignored (no emissions)', () async {
      final ws = FakeWebSocketClient();
      ws.emitConnection(ConnectionStatus.ctrlWsConnected);

      final repo = TelemetryRepositoryImpl(ws);
      await repo.startTelemetry();

      final sub1 = repo.observeTelemetry().listen((_) {
        fail('should not emit telemetry for unknown topic');
      });
      final sub2 = repo.observeMowerStatus().listen((_) {
        fail('should not emit status for unknown topic');
      });

      ws.emitMessage({'topic': 'nope', 'data': {}});

      // Give the stream a short chance to (not) emit.
      await Future<void>.delayed(const Duration(milliseconds: 20));

      await sub1.cancel();
      await sub2.cancel();
    });
  });
}
