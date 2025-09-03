import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/websocket_adapter.dart';

typedef MessageHandler = void Function(Map<String, dynamic> message);
typedef JsonMap = Map<String, dynamic>;

abstract class IWebSocketClient {
  Uri? get endpoint;
  void setEndpoint(Uri uri);

  Future<void> connect({Uri uri});
  Future<void> disconnect();

  void send(Map<String, dynamic> message);

  void dispose();

  Stream<Map<String, dynamic>>? get messages;
  bool get isConnected;
}

abstract class BaseWebSocketClient implements IWebSocketClient {
  final WebSocketAdapter _websocketAdapter;
  final WsPayloadMode payloadMode;

  BaseWebSocketClient(this._websocketAdapter,
      { this.payloadMode = WsPayloadMode.jsonAndBinary });

  Uri? _endpoint;

  final StreamController<JsonMap> _jsonCtrl = StreamController<JsonMap>.broadcast();

  @override
  Uri? get endpoint => _endpoint;

  @override
  void setEndpoint(Uri uri) => _endpoint = uri;

  @override
  Future<void> connect({Uri? uri}) async {
    if (uri != null) _endpoint = uri;
    final ep = _endpoint;
    if (ep == null) {
      throw StateError('${this.runtimeType}: endpoint is not set');
    }

    if (isConnected) return;

    // Bridge adapter streams to client-specific controllers
    // Subscribers can attach before or after connect.
    _websocketAdapter.json.listen(_jsonCtrl.add, onError: _jsonCtrl.addError);

    await _websocketAdapter.openWebsocketChannel(
      uri: ep,
      mode: payloadMode,
      onError: (e, [st]) { _jsonCtrl.addError(e, st); },
      onConnectionChanged: (open) {
        if (kDebugMode) {
          print("WS${payloadMode.name}: connection is ${open ? "open" : "closed"}");
        }
      }
    );
  }

  @override
  Future<void> disconnect() async =>
      await _websocketAdapter.close(manuallyClosed: true);

  @override
  void dispose() {
    if (!_jsonCtrl.isClosed) _jsonCtrl.close();
    _websocketAdapter.dispose();
  }

  @override
  bool get isConnected => _websocketAdapter.isOpen;

  @override
  void send(JsonMap message) {
    if (!isConnected) {
      if (kDebugMode) {
        print("WS[${runtimeType.toString()}]: send attempted while not connected, cannot send message: $message");
      }
      return;
    }
    _websocketAdapter.sendText(jsonEncode(message));
  }

  @override
  Stream<JsonMap>? get messages => _jsonCtrl.stream;

}

class ControlWebSocketClient extends BaseWebSocketClient {
  ControlWebSocketClient({WebSocketAdapter? adapter})
      : super(adapter ?? WebSocketAdapter(), payloadMode: WsPayloadMode.jsonOnly);
}

class BinaryWebSocketClient extends BaseWebSocketClient {
  BinaryWebSocketClient({WebSocketAdapter? adapter})
      : super(adapter ?? WebSocketAdapter(), payloadMode: WsPayloadMode.jsonAndBinary);

  Stream<Uint8List>? get binary => _websocketAdapter.binary;
}