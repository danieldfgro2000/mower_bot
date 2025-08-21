import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
   final IWebSocketClient _webSocketClient;

  MowerConnectionRepositoryImpl(this._webSocketClient);

  @override
  Future<void> connect(String ipAddress, int port) async {
    final uri = Uri(scheme:'ws', host: ipAddress, port:port, path:'/');

    try { await  _webSocketClient.connect(uri);} catch (e) {
      if (kDebugMode) print('Connection failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async => await _webSocketClient.disconnect();

  @override
  bool get isConnected => _webSocketClient.isConnected; // Expose the connection status stream
}