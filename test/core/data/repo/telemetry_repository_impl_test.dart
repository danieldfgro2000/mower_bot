import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/repo/telemetry_repository_impl.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

import '../../../test_helpers/fake_websocket_client.dart';

void main() {
  group('TelemetryRepositoryImpl', () {
    test('startTelemetry throws when websocket is not connected', () async {
      final ws = FakeWebSocketClient();
      final repo = TelemetryRepositoryImpl(ws);

      expect(repo.startTelemetry, throwsA(isA<Exception>()));
    });

    test('telemetry topic emits mapped TelemetryDataModel', () async {
      final ws = FakeWebSocketClient();
      ws.emitConnection(ConnectionStatus.ctrlWsConnected);

      final repo = TelemetryRepositoryImpl(ws);
      await repo.startTelemetry();

      // Attach listener before emitting.
      final future = expectLater(repo.observeTelemetry(), emits(isA<Object>()));

      ws.emitMessage({
        'topic': 'telemetry',
        'data': {
          // Keep payload minimal; mapper should tolerate missing fields.
          'timestamp': 1,
        },
      });

      await future;
    });

    test('status topic emits mapped MowerStatusModel even when envelope has missing telemetry field',
        () async {
      final ws = FakeWebSocketClient();
      ws.emitConnection(ConnectionStatus.ctrlWsConnected);

      final repo = TelemetryRepositoryImpl(ws);
      await repo.startTelemetry();

      final future = expectLater(repo.observeMowerStatus(), emits(isA<Object>()));

      ws.emitMessage({
        'topic': 'status',
        'data': {
          // note: telemetry key missing -> repo uses {} fallback
        },
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
