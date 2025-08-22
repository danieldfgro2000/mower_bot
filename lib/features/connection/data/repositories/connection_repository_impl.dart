import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
  final IWebSocketClient _webSocketClient;

  MowerConnectionRepositoryImpl(this._webSocketClient);

  @override
  Stream<Map<String, dynamic>> messages() => _webSocketClient.messages;

  final _errorCtrl = StreamController<Object>.broadcast();
  StreamSubscription? _sub;

  @override
  Future<void> connect(String ipAddress, int port) async {
    final uri = Uri(scheme: 'ws', host: ipAddress, port: port, path: '/');

    try {
      await _webSocketClient.connect(uri);
      await _sub?.cancel();
      _sub = _webSocketClient.messages.listen(
        (_) {},
        onError: (e, st) => _errorCtrl.add(e),
      );
    } catch (e) {
      if (kDebugMode) print('Connection failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _sub?.cancel();
    await _webSocketClient.disconnect();
  }

  @override
  bool get isConnected => _webSocketClient.isConnected;

  @override
  Stream<Object> errors() => _errorCtrl.stream;
}
