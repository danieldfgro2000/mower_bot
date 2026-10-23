import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/data/network/websocket_adapter.dart';
import 'package:mower_bot/core/data/network/websocket_config.dart';
import 'package:mower_bot/core/device/model/connection_status.dart';

typedef MessageHandler = void Function(Map<String, dynamic> message);
typedef JsonMap = Map<String, dynamic>;

abstract class IWebSocketClient {
  Uri? get endpoint;

  void setEndpoint(Uri uri);

  Future<void> connect({bool fromReconnect = false});

  Future<void> disconnect();

  bool send(Map<String, dynamic> message);

  Future<void> dispose();

  Stream<Map<String, dynamic>> get messages;

  Stream<ConnectionStatus> get connectionChanged;

  bool get isConnected;
}

abstract class BaseWebSocketClient implements IWebSocketClient {
  final WebSocketAdapter _websocketAdapter;
  final WsPayloadMode _payloadMode;

  BaseWebSocketClient(
    this._websocketAdapter, {
    WsPayloadMode payloadMode = WsPayloadMode.jsonAndBinary,
  }) : _payloadMode = payloadMode;

  Uri? _endpoint;

  final _jsonCtrl = StreamController<JsonMap>.broadcast();
  final _connectionChanges = StreamController<ConnectionStatus>.broadcast();

  StreamSubscription<JsonMap>? _jsonSub;

  @override
  Uri? get endpoint => _endpoint;

  @override
  void setEndpoint(Uri uri) => _endpoint = uri;

  @override
  Future<void> connect({bool fromReconnect = false}) async {
    if (isConnected) return;
    if (_endpoint == null) {
      throw StateError('$runtimeType: endpoint is not set');
    }

    _jsonSub ??= _websocketAdapter.json.listen(
      _jsonCtrl.add,
      onError: _jsonCtrl.addError,
    );

    await _websocketAdapter.openWebsocketChannel(
      uri: _endpoint,
      mode: _payloadMode,
      onError: _jsonCtrl.addError,
      onConnectionChanged: _connectionChanges.add,
      onReconnect: connect,
    );
  }

  @override
  Future<void> disconnect() async =>
      await _websocketAdapter.close(manuallyClosed: true);

  @override
  Future<void> dispose() async {
    await _jsonSub?.cancel();
    _jsonSub = null;
    await _jsonCtrl.close();
    await _connectionChanges.close();
    await _websocketAdapter.dispose();
  }

  @override
  bool get isConnected => _websocketAdapter.isOpen;

  WebSocketConfig get config => _websocketAdapter.wscfg;

  @override
  bool send(JsonMap message) {
    if (!isConnected) {
      if (kDebugMode) {
        print(
          "WS[${runtimeType.toString()}]: send attempted while not connected, cannot send message: $message",
        );
      }
      return false;
    }
    _websocketAdapter.sendText(jsonEncode(message));
    return true;
  }

  @override
  Stream<JsonMap> get messages => _jsonCtrl.stream;

  @override
  Stream<ConnectionStatus> get connectionChanged => _connectionChanges.stream;
}

class ControlWebSocketClient extends BaseWebSocketClient {
  ControlWebSocketClient({WebSocketAdapter? adapter, WebSocketConfig? config})
    : assert(adapter == null || config == null),
      super(
        adapter ?? WebSocketAdapter(config: config),
        payloadMode: WsPayloadMode.jsonOnly,
      );
}

class BinaryWebSocketClient extends BaseWebSocketClient {
  BinaryWebSocketClient({WebSocketAdapter? adapter, WebSocketConfig? config})
    : assert(adapter == null || config == null),
      super(
        adapter ?? WebSocketAdapter(config: config),
        payloadMode: WsPayloadMode.jsonAndBinary,
      );

  Stream<Uint8List>? get binary => _websocketAdapter.binary;
}
