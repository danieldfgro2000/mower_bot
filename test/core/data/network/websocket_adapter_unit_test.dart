import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/network/websocket_adapter.dart';
import 'package:mower_bot/core/data/network/websocket_config.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

Future<(HttpServer, Uri)> _startWsServer({
  required Future<void> Function(WebSocket ws) onClient,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);

  server.listen((HttpRequest req) async {
    if (!WebSocketTransformer.isUpgradeRequest(req)) {
      req.response
        ..statusCode = HttpStatus.badRequest
        ..close();
      return;
    }

    final socket = await WebSocketTransformer.upgrade(req);
    await onClient(socket);
  });

  final uri = Uri.parse('ws://${server.address.host}:${server.port}');
  return (server, uri);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WebSocketAdapter', () {
    test('throws when endpoint is not set', () async {
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(enableReachability: false),
        tcpProbe: (_) async => true,
      );

      final errors = <String>[];
      final statuses = <ConnectionStatus>[];

      expect(
        () => adapter.openWebsocketChannel(
          uri: null,
          onError: (e, [st]) => errors.add(e),
          onConnectionChanged: statuses.add,
          onReconnect: () {},
        ),
        throwsA(isA<StateError>()),
      );

      expect(statuses, contains(ConnectionStatus.disconnected));
      expect(errors.single, contains('endpoint is not set'));
    });

    test('reachability failure reports hostUnreachable and schedules reconnect', () async {
      var reconnectCalled = 0;

      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: true,
          retry1sec: Duration.zero,
          retry5sec: Duration.zero,
          max5attempts: 1,
        ),
        tcpProbe: (_) async => false,
      );

      final statuses = <ConnectionStatus>[];
      final errors = <String>[];

      await adapter.openWebsocketChannel(
        uri: Uri.parse('ws://127.0.0.1:1234'),
        onError: (e, [st]) => errors.add(e),
        onConnectionChanged: statuses.add,
        onReconnect: () {
          reconnectCalled++;
        },
      );

      // Reconnect callback is scheduled via Future.delayed.
      await Future<void>.delayed(Duration.zero);

      expect(statuses, contains(ConnectionStatus.hostUnreachable));
      expect(errors.any((e) => e.contains('Cannot reach')), isTrue);
      expect(reconnectCalled, 1);
    });

    test('max reconnect attempts halts reconnecting and reports an error', () async {
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: true,
          retry1sec: Duration.zero,
          retry5sec: Duration.zero,
          max5attempts: 0,
        ),
        tcpProbe: (_) async => false,
      );

      final errors = <String>[];
      await adapter.openWebsocketChannel(
        uri: Uri.parse('ws://127.0.0.1:1234'),
        onError: (e, [st]) => errors.add(e),
        onConnectionChanged: (_) {},
        onReconnect: () {},
      );

      expect(errors.any((e) => e.contains('Max reconnect attempts reached')), isTrue);
    });

    test('connects and emits decoded json; reports decode errors', () async {
      final (server, uri) = await _startWsServer(onClient: (ws) async {
        ws.add(jsonEncode({'a': 1}));
        ws.add('{bad json');
        await ws.close();
      });
      addTearDown(() async => server.close(force: true));

      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(enableReachability: false),
        tcpProbe: (_) async => true,
      );

      final received = <Map<String, dynamic>>[];
      final errors = <String>[];

      final sub = adapter.json.listen(received.add);
      addTearDown(sub.cancel);

      await adapter.openWebsocketChannel(
        uri: uri,
        mode: WsPayloadMode.jsonOnly,
        onError: (e, [st]) => errors.add(e),
        onConnectionChanged: (_) {},
        onReconnect: () {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(received, [{'a': 1}]);
      expect(errors.any((e) => e.contains('Error decoding message')), isTrue);
    });

    test('binaryOnly mode ignores strings and emits bytes', () async {
      final (server, uri) = await _startWsServer(onClient: (ws) async {
        // String should be ignored in binaryOnly.
        ws.add(jsonEncode({'ignored': true}));
        ws.add(<int>[1, 2, 3]);
        await ws.close();
      });
      addTearDown(() async => server.close(force: true));

      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(enableReachability: false),
        tcpProbe: (_) async => true,
      );

      final jsonReceived = <Map<String, dynamic>>[];
      final binReceived = <Uint8List>[];

      final s1 = adapter.json.listen(jsonReceived.add);
      final s2 = adapter.binary.listen(binReceived.add);
      addTearDown(() async {
        await s1.cancel();
        await s2.cancel();
      });

      await adapter.openWebsocketChannel(
        uri: uri,
        mode: WsPayloadMode.binaryOnly,
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(jsonReceived, isEmpty);
      expect(binReceived.single, Uint8List.fromList([1, 2, 3]));
    });
  });
}
