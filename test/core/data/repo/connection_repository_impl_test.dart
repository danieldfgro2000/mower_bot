import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/repo/connection_repository_impl.dart';
import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

import '../../../test_helpers/fake_websocket_client.dart';

void main() {
  group('MowerConnectionRepositoryImpl (ctrl ws)', () {
    test('connectCtrlWs sets ws endpoint with expected scheme/host/port', () async {
      final ws = FakeWebSocketClient();
      final repo = MowerConnectionRepositoryImpl(ws);

      await repo.connectCtrlWs('10.0.0.42', 85);

      expect(ws.endpoint, isNotNull);
      expect(ws.endpoint!.scheme, 'ws');
      expect(ws.endpoint!.host, '10.0.0.42');
      expect(ws.endpoint!.port, 85);
      expect(ws.endpoint!.path, '/');
    });

    test('connectCtrlWs throws ValidationException.required when ip is empty', () async {
      final ws = FakeWebSocketClient();
      final repo = MowerConnectionRepositoryImpl(ws);

      expect(
        () => repo.connectCtrlWs('', 85),
        throwsA(isA<ValidationException>()),
      );
    });

    test('ctrlWsErr maps "Cannot reach" errors to NetworkException.hostUnreachable', () async {
      final ws = FakeWebSocketClient();
      final repo = MowerConnectionRepositoryImpl(ws);

      await repo.connectCtrlWs('10.0.0.42', 85);

      final future = expectLater(
        repo.ctrlWsErr(),
        emits(isA<NetworkException>().having((e) => e.code, 'code', AppExceptionCode.hostUnreachable)),
      );

      ws.emitMessageError('Cannot reach 10.0.0.42');
      await future;
    });

    test('ctrlWsErr maps "Max reconnect attempts" errors to NetworkException.connectionFailed', () async {
      final ws = FakeWebSocketClient();
      final repo = MowerConnectionRepositoryImpl(ws);

      await repo.connectCtrlWs('10.0.0.42', 85);

      final future = expectLater(
        repo.ctrlWsErr(),
        emits(isA<NetworkException>().having((e) => e.code, 'code', AppExceptionCode.connectionFailed)),
      );

      ws.emitMessageError('Max reconnect attempts reached');
      await future;
    });

    test('ctrlWsConnected streams through from client', () async {
      final ws = FakeWebSocketClient();
      final repo = MowerConnectionRepositoryImpl(ws);

      await repo.connectCtrlWs('10.0.0.42', 85);

      final future = expectLater(
        repo.ctrlWsConnected()!,
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.ctrlWsConnected,
          ConnectionStatus.disconnected,
        ]),
      );

      ws.emitConnection(ConnectionStatus.connecting);
      ws.emitConnection(ConnectionStatus.ctrlWsConnected);
      ws.emitConnection(ConnectionStatus.disconnected);

      await future;
    });
  });
}
