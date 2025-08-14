import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef MessageHandler = void Function(Map<String, dynamic> message);

abstract class IWebSocketClient {
  Stream<Map<String, dynamic>> get messages;
  Future<void> connect(String uri);
  Future<void> disconnect();
  void send(Map<String, dynamic> message);
  bool get isConnected;
}

class WebSocketClient implements IWebSocketClient {
  WebSocketChannel? _channel;
  late final  StreamController<Map<String, dynamic>> _controller;
  bool _isConnected = false;

  WebSocketClient() {
    _controller = StreamController<Map<String, dynamic>>.broadcast();
  }

  @override
  Stream<Map<String, dynamic>> get messages => _controller.stream;

  @override
  Future<void> connect(String uri) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(uri));
      _isConnected = true;

      _channel!.stream.listen(
        (data) {
          try {
            final message = jsonDecode(data);
            if (message is Map<String, dynamic>) {
              _controller.add(message);
            }
          } catch (e) {
            print("Error decoding message: $e");
          }
        }, onError: (error) {
          _isConnected = false;
          _controller.addError(error);
      }, onDone: () {
          _isConnected = false;
        });
    } catch (e) {
      _isConnected = false;
      _controller.addError(e);
    }
  }

  @override
  void send(Map<String, dynamic> message) {
    if(_isConnected && _channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  @override
  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close(status.normalClosure);
      _isConnected = false;

    }
  }

  @override
  bool get isConnected => _isConnected;
}