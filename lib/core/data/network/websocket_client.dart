import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/data/network/websocket_adapter.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

typedef MessageHandler = void Function(Map<String, dynamic> message);
typedef JsonMap = Map<String, dynamic>;

abstract class IWebSocketClient {
  Uri? get endpoint;

  void setEndpoint(Uri uri);

  Future<void> connect();

  Future<void> disconnect();

  void send(Map<String, dynamic> message);

  void dispose();

  Stream<Map<String, dynamic>> get messages;

  Stream<ConnectionStatus> get connectionChanged;

  bool get isConnected;
}

abstract class BaseWebSocketClient implements IWebSocketClient {
  final WebSocketAdapter _websocketAdapter;
  final WsPayloadMode payloadMode;

  BaseWebSocketClient(
    this._websocketAdapter, {
    this.payloadMode = WsPayloadMode.jsonAndBinary,
  });

  Uri? _endpoint;

  final _jsonCtrl = StreamController<JsonMap>.broadcast();
  final _connectionChanges = StreamController<ConnectionStatus>.broadcast();

  StreamSubscription<JsonMap>? _jsonSub;

  @override
  Uri? get endpoint => _endpoint;

  @override
  void setEndpoint(Uri uri) => _endpoint = uri;

  @override
  Future<void> connect() async {
    if (isConnected) return;
    if (_endpoint == null) throw StateError('$runtimeType: endpoint is not set');

    _jsonSub ??= _websocketAdapter.json.listen(
      _jsonCtrl.add,
      onError: _jsonCtrl.addError,
    );

    await _websocketAdapter.openWebsocketChannel(
      uri: _endpoint,
      mode: payloadMode,
      onError: (e, [st]) => _jsonCtrl.addError(e, st),
      onConnectionChanged: _connectionChanges.add,
      onReconnect: _onReconnect,
    );
  }

  void _onReconnect() async {
    await _websocketAdapter.openWebsocketChannel(
      uri: _endpoint,
      mode: payloadMode,
      onError: (e, [st]) => _jsonCtrl.addError(e, st),
      onConnectionChanged: _connectionChanges.add,
      onReconnect: () {},
    );
  }

  @override
  Future<void> disconnect() async =>
      await _websocketAdapter.close(manuallyClosed: true);

  @override
  void dispose() {
    _jsonSub?.cancel();
    _jsonSub = null;
    _jsonCtrl.close();
    _connectionChanges.close();
    _websocketAdapter.dispose();
  }

  @override
  bool get isConnected => _websocketAdapter.isOpen;

  @override
  void send(JsonMap message) {
    if (!isConnected) {
      if (kDebugMode) {
        print(
          "WS[${runtimeType.toString()}]: send attempted while not connected, cannot send message: $message",
        );
      }
      return;
    }
    _websocketAdapter.sendText(jsonEncode(message));
  }

  @override
  Stream<JsonMap> get messages => _jsonCtrl.stream;

  @override
  Stream<ConnectionStatus> get connectionChanged => _connectionChanges.stream;
}

class ControlWebSocketClient extends BaseWebSocketClient {
  ControlWebSocketClient({WebSocketAdapter? adapter})
    : super(adapter ?? WebSocketAdapter(), payloadMode: WsPayloadMode.jsonOnly);
}

class BinaryWebSocketClient extends BaseWebSocketClient {
  BinaryWebSocketClient({WebSocketAdapter? adapter})
    : super(
        adapter ?? WebSocketAdapter(),
        payloadMode: WsPayloadMode.jsonAndBinary,
      );

  Stream<Uint8List>? get binary => _websocketAdapter.binary;
}
