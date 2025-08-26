import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/helpers.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef MessageHandler = void Function(Map<String, dynamic> message);
typedef JsonMap = Map<String, dynamic>;

abstract class IWebSocketClient {
  Uri? get endpoint;

  void setEndpoint(Uri uri);

  Future<void> connect({Uri uri});

  Future<void> disconnect();

  void send(Map<String, dynamic> message);

  void dispose();

  Stream<Uint8List> get binary;

  Stream<Map<String, dynamic>>? get messages;

  bool get isConnected;
}

class ControlWebSocketClient implements IWebSocketClient {
  final NetworkHelpers _helpers;
  Uri? _endpoint;

  late final StreamController<Map<String, dynamic>> _jsonStringController;
  late final StreamController<Uint8List> _binaryController;

  ControlWebSocketClient({NetworkHelpers? helpers})
    : _helpers = helpers ?? NetworkHelpers() {
    _jsonStringController = StreamController<Map<String, dynamic>>.broadcast();
    _binaryController = StreamController<Uint8List>.broadcast();
  }

  @override
  Uri? get endpoint => _endpoint;

  @override
  void setEndpoint(Uri uri) => _endpoint = uri;

  @override
  Future<void> connect({Uri? uri}) async {
    if (uri != null) _endpoint = uri;
    final ep = _endpoint;
    if (ep == null) {
      throw StateError('ControlWebSocketClient: endpoint is not set');
    }

    if (isConnected) return;

    await _helpers.openWebsocketChannel(
      uri: ep,
      onJson: (msg) => _jsonStringController.add(msg),
      onBinary: null,
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

class VideoWebSocketClient implements IWebSocketClient {
  final NetworkHelpers _helpers;
  Uri? _endpoint;

  late final StreamController<Uint8List> _binaryController;


  VideoWebSocketClient({NetworkHelpers? helpers})
      : _helpers = helpers ?? NetworkHelpers() {
    _binaryController = StreamController<Uint8List>.broadcast();
  }

  @override
  Stream<Uint8List> get binary => _binaryController.stream;

  @override
  Uri? get endpoint => _endpoint;

  @override
  void setEndpoint(Uri uri) => _endpoint = uri;

  @override
  Future<void> connect({Uri? uri}) async {
    if (uri != null) _endpoint = uri;
    final ep = _endpoint;
    if (ep == null) {
      throw StateError('VideoWebSocketClient: endpoint is not set');
    }

    print('Connecting to video WS at $ep');

    if (isConnected) return;

    return _helpers.openWebsocketChannel(
      uri: ep,
      onJson: null,
      onBinary: (data) => _binaryController.add(data),
      onError: (e, [st]) => _binaryController.addError(e, st),
      onConnectionChanged: (open) {
        if (kDebugMode) {
          print("WS: connection is ${open ? "open" : "closed"}");
        }
      },
    );
  }

  @override
  Future<void> disconnect() async =>
      await _helpers.closeWebSocketChannel(manuallyClosed: true);

  @override
  void dispose() {
    if (!_binaryController.isClosed) _binaryController.close();
    _helpers.dispose();
  }

  @override
  bool get isConnected => _helpers.isOpen;

  @override
  Stream<Map<String, dynamic>>? get messages => null;

  @override
  void send(Map<String, dynamic> message) {}
}