import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/features/paths/data/repository/path_repository_remote_impl.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class _FakeWebSocketClient implements IWebSocketClient {
  Uri? _endpoint;
  final _messages = StreamController<Map<String, dynamic>>.broadcast();
  final _conn = StreamController<ConnectionStatus>.broadcast();

  bool connected = true;
  Map<String, dynamic>? lastSent;
  bool get hasMessageListener => _messages.hasListener;

  @override
  Uri? get endpoint => _endpoint;

  @override
  void setEndpoint(Uri uri) => _endpoint = uri;

  @override
  bool get isConnected => connected;

  @override
  Stream<Map<String, dynamic>> get messages => _messages.stream;

  @override
  Stream<ConnectionStatus> get connectionChanged => _conn.stream;

  @override
  Future<void> connect({bool fromReconnect = false}) async {}

  @override
  Future<void> disconnect() async {}

  @override
  bool send(Map<String, dynamic> message) {
    if (!isConnected) return false;
    lastSent = message;
    return true;
  }

  @override
  Future<void> dispose() async {
    await _messages.close();
    await _conn.close();
  }

  void emitMessage(Map<String, dynamic> msg) => _messages.add(msg);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PathRepositoryRemote', () {
    test(
      'fetchPaths returns [] when not connected and does not send',
      () async {
        final ws = _FakeWebSocketClient()..connected = false;
        final repo = PathRepositoryRemote(ws);

        final paths = await repo.fetchPaths();
        expect(paths, isEmpty);
        expect(ws.lastSent, isNull);

        await ws.dispose();
      },
    );

    test(
      'fetchPaths sends list_paths and returns parsed names (strips .csv)',
      () async {
        final ws = _FakeWebSocketClient();
        final repo = PathRepositoryRemote(
          ws,
          listTimeout: const Duration(milliseconds: 200),
        );

        // Start fetch, then reply.
        final future = repo.fetchPaths();

        // Should have sent the list command quickly.
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(ws.lastSent, isNotNull);
        expect(ws.lastSent!['topic'], 'drive');
        expect(ws.lastSent!['data'], {'cmd': 'list_paths'});

        ws.emitMessage({
          'topic': 'pathList',
          'data': {
            'paths': ['a.csv', 'b', 3],
          },
        });

        final paths = await future;
        expect(paths, ['a', 'b', '3']);

        await ws.dispose();
      },
    );

    test(
      'fetchPaths tolerates malformed messages and times out to []',
      () async {
        final ws = _FakeWebSocketClient();
        final repo = PathRepositoryRemote(
          ws,
          listTimeout: const Duration(milliseconds: 50),
        );

        final f = repo.fetchPaths();
        await Future<void>.delayed(const Duration(milliseconds: 5));

        // Emit malformed message (no topic)
        ws.emitMessage({'data': 'nope'});
        final paths = await f;
        expect(paths, isEmpty);

        await ws.dispose();
      },
    );

    test('play/stop/delete are no-ops when not connected', () async {
      final ws = _FakeWebSocketClient()..connected = false;
      final repo = PathRepositoryRemote(ws);

      expect(await repo.playPath('x'), CommandSubmissionResult.disconnected);
      expect(await repo.stopPath('x'), CommandSubmissionResult.disconnected);
      expect(await repo.deletePath('x'), CommandSubmissionResult.disconnected);

      expect(ws.lastSent, isNull);
      await ws.dispose();
    });

    test(
      'play/stop/delete send expected drive envelopes when connected',
      () async {
        final ws = _FakeWebSocketClient();
        final repo = PathRepositoryRemote(ws);

        expect(await repo.playPath('my'), CommandSubmissionResult.submitted);
        expect(ws.lastSent, {
          'topic': 'drive',
          'data': {'cmd': 'play_path', 'fileName': 'my'},
        });

        expect(await repo.stopPath('my'), CommandSubmissionResult.submitted);
        expect(ws.lastSent, {
          'topic': 'drive',
          'data': {'cmd': 'stop_path'},
        });

        expect(await repo.deletePath('my'), CommandSubmissionResult.submitted);
        expect(ws.lastSent, {
          'topic': 'drive',
          'data': {'cmd': 'delete_path', 'fileName': 'my'},
        });

        await ws.dispose();
      },
    );

    test(
      'recording commands report submission and preserve wire format',
      () async {
        final ws = _FakeWebSocketClient();
        final repo = PathRepositoryRemote(ws);

        expect(await repo.startRecord(), CommandSubmissionResult.submitted);
        expect(ws.lastSent, {
          'topic': 'drive',
          'data': {'cmd': 'start_record'},
        });

        expect(
          await repo.stopRecord('yard'),
          CommandSubmissionResult.submitted,
        );
        expect(ws.lastSent, {
          'topic': 'drive',
          'data': {'cmd': 'stop_record', 'fileName': 'yard'},
        });

        expect(await repo.stopRecord(''), CommandSubmissionResult.submitted);
        expect(ws.lastSent, {
          'topic': 'drive',
          'data': {'cmd': 'stop_record', 'fileName': ''},
        });

        await ws.dispose();
      },
    );

    test('recording commands report disconnection without sending', () async {
      final ws = _FakeWebSocketClient()..connected = false;
      final repo = PathRepositoryRemote(ws);

      expect(await repo.startRecord(), CommandSubmissionResult.disconnected);
      expect(
        await repo.stopRecord('yard'),
        CommandSubmissionResult.disconnected,
      );
      expect(ws.lastSent, isNull);

      await ws.dispose();
    });

    test('dispose releases the diagnostic message listener', () async {
      final ws = _FakeWebSocketClient();
      addTearDown(ws.dispose);
      final repo = PathRepositoryRemote(ws);

      expect(ws.hasMessageListener, isTrue);
      await repo.dispose();

      expect(ws.hasMessageListener, isFalse);
    });
  });
}
