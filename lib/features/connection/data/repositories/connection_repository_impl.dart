import 'dart:async';

import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
   final IWebSocketClient _webSocketClient;

   String? _ipAddress;
   int? _port;

   final _controller = StreamController<bool>.broadcast();

  MowerConnectionRepositoryImpl(this._webSocketClient);

  @override
  Future<void> connect(String ipAddress, int port) async {
    final url = 'ws://$ipAddress:$port';
    try {
      await  _webSocketClient.connect(url);
      _ipAddress = ipAddress;
      _port = port;
      _controller.add(true);
    } catch (e) {
      _controller.add(false);
      print('Connection failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _webSocketClient.disconnect();

    _ipAddress = null;
    _port = null;
    _controller.add(false);
  }

  @override
  Future<bool> checkConnectionStatus() async {
    return _webSocketClient.isConnected;
  }

  @override
  Stream<bool> connectionChanges() => _controller.stream;


  String? get ipAddress => _ipAddress; // Getter for IP address
  int? get port => _port; // Getter for port

  @override
  Future<String?> getTelemetryUrl() async {
    return (_ipAddress != null && _port != null)
        ? 'ws://$_ipAddress:$_port'
        : null;
  }

  @override
  Stream<bool> get connectionStatusStream => _controller.stream; // Expose the connection status stream
}