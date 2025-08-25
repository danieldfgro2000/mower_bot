import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/helpers.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef MessageHandler = void Function(Map<String, dynamic> message);
typedef JsonMap = Map<String, dynamic>;

abstract class IWebSocketClient {
  Future<void> connect(Uri uri);

  Future<void> disconnect();

  void send(Map<String, dynamic> message);
  void dispose();

  Stream<Uint8List> get binary;

  Stream<Map<String, dynamic>> get messages;

  bool get isConnected;
}

class WebSocketClient implements IWebSocketClient {
  final NetworkHelpers _helpers;

  late final StreamController<Map<String, dynamic>> _jsonStringController;
  late final StreamController<Uint8List> _binaryController;

  WebSocketClient({NetworkHelpers? helpers})
    : _helpers = helpers ?? NetworkHelpers() {
    _jsonStringController = StreamController<Map<String, dynamic>>.broadcast();
    _binaryController = StreamController<Uint8List>.broadcast();
  }


  @override
  Future<void> connect(Uri uri) async {
    if (isConnected) return;

    await _helpers.openWebsocketChannel(
      uri,
      onJson: (msg) => _jsonStringController.add(msg),
      onBinary: (data) => _binaryController.add(data),
      onError: (e, [st]) => _jsonStringController.addError(e, st),
      onConnectionChanged: (open) {
        if (kDebugMode) {
          print("WS: connection is ${open ? "open" : "closed"}");
        }
      },
    );
  }

  @override
  Future<void> disconnect() async => await _helpers.closeWebSocketChannel(manuallyClosed: true);

  @override
  void send(Map<String, dynamic> message) {
    if (!isConnected) {
      if (kDebugMode) {
        print("WS: send attempted while not connected, cannot send message: $message");
      }
      return;
    }
    _helpers.sendText(jsonEncode(message));
  }

  @override
  void dispose() {
    if (!_jsonStringController.isClosed) _jsonStringController.close();
    if (!_binaryController.isClosed) _binaryController.close();
    _helpers.dispose();
  }

  @override
  Stream<JsonMap> get messages => _jsonStringController.stream;

  @override
  Stream<Uint8List> get binary => _binaryController.stream;

  @override
  bool get isConnected => _helpers.isOpen;
}
