import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/data/repo/path_repository_remote_impl.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class _FakeWebSocketClient implements IWebSocketClient {
  Uri? _endpoint;
  final _messages = StreamController<Map<String, dynamic>>.broadcast();
  final _conn = StreamController<ConnectionStatus>.broadcast();

  bool connected = true;
  Map<String, dynamic>? lastSent;

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
  void send(Map<String, dynamic> message) => lastSent = message;

  @override
  void dispose() {
    _messages.close();
    _conn.close();
  }

  void emitMessage(Map<String, dynamic> msg) => _messages.add(msg);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PathRepositoryRemote', () {
    test('fetchPaths returns [] when not connected and does not send', () async {
      final ws = _FakeWebSocketClient()..connected = false;
      final repo = PathRepositoryRemote(ws);

      final paths = await repo.fetchPaths();
      expect(paths, isEmpty);
      expect(ws.lastSent, isNull);

      ws.dispose();
    });

    test('fetchPaths sends list_paths and returns parsed names (strips .csv)', () async {
      final ws = _FakeWebSocketClient();
      final repo = PathRepositoryRemote(ws, listTimeout: const Duration(milliseconds: 200));

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

      ws.dispose();
    });

    test('fetchPaths tolerates malformed messages and times out to []', () async {
      final ws = _FakeWebSocketClient();
      final repo = PathRepositoryRemote(ws, listTimeout: const Duration(milliseconds: 50));

      final f = repo.fetchPaths();
      await Future<void>.delayed(const Duration(milliseconds: 5));

      // Emit malformed message (no topic)
      ws.emitMessage({'data': 'nope'});
      final paths = await f;
      expect(paths, isEmpty);

      ws.dispose();
    });

    test('play/stop/delete are no-ops when not connected', () async {
      final ws = _FakeWebSocketClient()..connected = false;
      final repo = PathRepositoryRemote(ws);

      await repo.playPath('x');
      await repo.stopPath('x');
      await repo.deletePath('x');

      expect(ws.lastSent, isNull);
      ws.dispose();
    });

    test('play/stop/delete send expected drive envelopes when connected', () async {
      final ws = _FakeWebSocketClient();
      final repo = PathRepositoryRemote(ws);

      await repo.playPath('my');
      expect(ws.lastSent, {
        'topic': 'drive',
        'data': {'cmd': 'play_path', 'fileName': 'my'},
      });

      await repo.stopPath('my');
      expect(ws.lastSent, {
        'topic': 'drive',
        'data': {'cmd': 'stop_path'},
      });

      await repo.deletePath('my');
      expect(ws.lastSent, {
        'topic': 'drive',
        'data': {'cmd': 'delete_path', 'fileName': 'my'},
      });

      ws.dispose();
    });
  });
}
