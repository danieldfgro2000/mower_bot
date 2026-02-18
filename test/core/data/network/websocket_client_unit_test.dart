import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/network/websocket_adapter.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/data/network/websocket_config.dart';

Future<(HttpServer, Uri, List<String>)> _startEchoWsServer() async {
  final received = <String>[];

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((HttpRequest req) async {
    if (!WebSocketTransformer.isUpgradeRequest(req)) {
      req.response
        ..statusCode = HttpStatus.badRequest
        ..close();
      return;
    }

    final socket = await WebSocketTransformer.upgrade(req);
    socket.listen((event) {
      if (event is String) received.add(event);
    });
  });

  final uri = Uri.parse('ws://${server.address.host}:${server.port}');
  return (server, uri, received);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BaseWebSocketClient (unit)', () {
    test('connect throws when endpoint is not set', () async {
      final client = ControlWebSocketClient(
        adapter: WebSocketAdapter(
          config: const WebSocketConfig(enableReachability: false),
          tcpProbe: (_) async => true,
        ),
      );

      expect(() => client.connect(), throwsA(isA<StateError>()));
      client.dispose();
    });

    test('send is ignored when not connected', () {
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(enableReachability: false),
        tcpProbe: (_) async => true,
      );

      final client = ControlWebSocketClient(adapter: adapter);
      expect(client.isConnected, isFalse);

      // Should not throw.
      client.send({'x': 1});
      client.dispose();
    });

    test('connects and send emits JSON string over the socket', () async {
      final (server, uri, received) = await _startEchoWsServer();
      addTearDown(() async => server.close(force: true));

      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(enableReachability: false),
        tcpProbe: (_) async => true,
      );

      final client = ControlWebSocketClient(adapter: adapter);
      addTearDown(client.dispose);

      client.setEndpoint(uri);
      await client.connect();

      expect(client.isConnected, isTrue);

      client.send({'hello': 'world'});
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(received, isNotEmpty);
      expect(jsonDecode(received.last), {'hello': 'world'});
    });

    test('connect is idempotent when already connected', () async {
      final (server, uri, _) = await _startEchoWsServer();
      addTearDown(() async => server.close(force: true));

      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(enableReachability: false),
        tcpProbe: (_) async => true,
      );
      final client = ControlWebSocketClient(adapter: adapter);
      addTearDown(client.dispose);

      client.setEndpoint(uri);
      await client.connect();
      await client.connect();

      expect(client.isConnected, isTrue);
    });
  });
}

