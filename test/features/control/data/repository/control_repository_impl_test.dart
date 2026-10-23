import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/control/data/repository/control_repository_impl.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

import '../../../../test_helpers/fake_websocket_client.dart';

void main() {
  group('ControlRepositoryImpl', () {
    test('videoStreamUrl returns null when not connected', () {
      final ws = FakeWebSocketClient();
      ws.setEndpoint(Uri.parse('ws://10.0.0.42:85/'));

      final repo = ControlRepositoryImpl(
        controlWebSocketClient: ws,
        binaryWebSocketClient: ws,
      );

      expect(repo.videoStreamUrl, isNull);
    });

    test(
      'videoStreamUrl derives http://{host} when connected and endpoint is set',
      () {
        final ws = FakeWebSocketClient();
        ws.setEndpoint(Uri.parse('ws://10.0.0.42:85/'));
        ws.emitConnection(ConnectionStatus.ctrlWsConnected);

        final repo = ControlRepositoryImpl(
          controlWebSocketClient: ws,
          binaryWebSocketClient: ws,
        );

        expect(repo.videoStreamUrl, 'http://10.0.0.42');
      },
    );

    test('sendDriveCommand reports disconnected when not connected', () async {
      final ws = FakeWebSocketClient();
      final repo = ControlRepositoryImpl(
        controlWebSocketClient: ws,
        binaryWebSocketClient: ws,
      );

      expect(
        await repo.sendDriveCommand({'speed': 1}),
        CommandSubmissionResult.disconnected,
      );
    });

    test(
      'sendDriveCommand wraps command in a drive MessageEnvelope and sends it',
      () async {
        final ws = FakeWebSocketClient();
        ws.emitConnection(ConnectionStatus.ctrlWsConnected);

        final repo = ControlRepositoryImpl(
          controlWebSocketClient: ws,
          binaryWebSocketClient: ws,
        );

        final result = await repo.sendDriveCommand({'speed': 123, 'angle': -5});

        expect(result, CommandSubmissionResult.submitted);
        expect(ws.sent, hasLength(1));
        final msg = ws.sent.single;
        expect(msg['topic'], 'drive');
        expect(msg['data'], {'speed': 123, 'angle': -5});
      },
    );
  });
}
