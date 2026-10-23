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

      // Reconnect callback is scheduled asynchronously.
      await Future<void>.delayed(Duration.zero);

      expect(statuses, contains(ConnectionStatus.hostUnreachable));
      expect(errors.any((e) => e.contains('Cannot reach')), isTrue);
      expect(reconnectCalled, 1);
    });

    test('manual close during backoff cancels reconnect', () async {
      var reconnectCalled = 0;
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: true,
          retry1sec: Duration(milliseconds: 40),
          retry5sec: Duration(milliseconds: 40),
        ),
        tcpProbe: (_) async => false,
      );

      final opening = adapter.openWebsocketChannel(
        uri: Uri.parse('ws://127.0.0.1:1234'),
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () => reconnectCalled++,
      );
      await Future<void>.delayed(Duration.zero);

      await adapter.close(manuallyClosed: true);
      await opening;
      await adapter.dispose();

      expect(reconnectCalled, 0);
    });

    test('dispose during backoff cancels reconnect', () async {
      var reconnectCalled = 0;
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: true,
          retry1sec: Duration(milliseconds: 40),
          retry5sec: Duration(milliseconds: 40),
        ),
        tcpProbe: (_) async => false,
      );

      final opening = adapter.openWebsocketChannel(
        uri: Uri.parse('ws://127.0.0.1:1234'),
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () => reconnectCalled++,
      );
      await Future<void>.delayed(Duration.zero);

      await adapter.dispose();
      await opening;

      expect(reconnectCalled, 0);
    });

    test('replacement open invalidates the prior reconnect callback', () async {
      var firstReconnects = 0;
      var secondReconnects = 0;
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: true,
          retry1sec: Duration(milliseconds: 40),
          retry5sec: Duration(milliseconds: 40),
        ),
        tcpProbe: (_) async => false,
      );

      final firstOpening = adapter.openWebsocketChannel(
        uri: Uri.parse('ws://127.0.0.1:1234'),
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () => firstReconnects++,
      );
      await Future<void>.delayed(Duration.zero);
      final secondOpening = adapter.openWebsocketChannel(
        uri: Uri.parse('ws://127.0.0.1:5678'),
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () => secondReconnects++,
      );

      await Future.wait([firstOpening, secondOpening]);
      await adapter.dispose();

      expect(firstReconnects, 0);
      expect(secondReconnects, 1);
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

    test('remote close of an established socket schedules reconnect', () async {
      final (server, uri) = await _startWsServer(
        onClient: (ws) => ws.close(),
      );
      addTearDown(() async => server.close(force: true));
      var reconnectCalled = 0;
      final statuses = <ConnectionStatus>[];
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: false,
          retry1sec: Duration.zero,
          retry5sec: Duration.zero,
          max5attempts: 1,
        ),
        tcpProbe: (_) async => true,
      );
      addTearDown(adapter.dispose);

      await adapter.openWebsocketChannel(
        uri: uri,
        onError: (_, [__]) {},
        onConnectionChanged: statuses.add,
        onReconnect: () => reconnectCalled++,
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(statuses, contains(ConnectionStatus.disconnected));
      expect(reconnectCalled, 1);
    });

    test('manual close of an established socket does not reconnect', () async {
      final connected = Completer<void>();
      final (server, uri) = await _startWsServer(onClient: (ws) async {
        connected.complete();
        await ws.done;
      });
      addTearDown(() async => server.close(force: true));
      var reconnectCalled = 0;
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: false,
          retry1sec: Duration.zero,
          retry5sec: Duration.zero,
        ),
        tcpProbe: (_) async => true,
      );
      addTearDown(adapter.dispose);

      await adapter.openWebsocketChannel(
        uri: uri,
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () => reconnectCalled++,
      );
      await connected.future;
      await adapter.close(manuallyClosed: true);
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(reconnectCalled, 0);
    });

    test('closure from a replaced socket cannot close the active session', () async {
      final firstClient = Completer<WebSocket>();
      final secondClient = Completer<WebSocket>();
      final (firstServer, firstUri) = await _startWsServer(onClient: (ws) async {
        firstClient.complete(ws);
        await ws.done;
      });
      final (secondServer, secondUri) = await _startWsServer(onClient: (ws) async {
        secondClient.complete(ws);
        await ws.done;
      });
      addTearDown(() async {
        await firstServer.close(force: true);
        await secondServer.close(force: true);
      });
      var staleReconnects = 0;
      var activeReconnects = 0;
      final adapter = WebSocketAdapter(
        config: const WebSocketConfig(
          enableReachability: false,
          retry1sec: Duration.zero,
          retry5sec: Duration.zero,
        ),
        tcpProbe: (_) async => true,
      );
      addTearDown(adapter.dispose);

      await adapter.openWebsocketChannel(
        uri: firstUri,
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () => staleReconnects++,
      );
      final replacedSocket = await firstClient.future;
      await adapter.openWebsocketChannel(
        uri: secondUri,
        onError: (_, [__]) {},
        onConnectionChanged: (_) {},
        onReconnect: () => activeReconnects++,
      );
      await secondClient.future;

      await replacedSocket.close();
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(adapter.isOpen, isTrue);
      expect(staleReconnects, 0);
      expect(activeReconnects, 0);
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
      addTearDown(adapter.dispose);

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
      addTearDown(adapter.dispose);

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
