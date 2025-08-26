import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/di/injection_container.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
  final IWebSocketClient _ctrlWSClient = sl<IWebSocketClient>(instanceName: 'ctrl');
  final IWebSocketClient _videoWSClient = sl<IWebSocketClient>(instanceName: 'video');

  @override
  Stream<Map<String, dynamic>>? messages() => _ctrlWSClient.messages;

  final _errorCtrl = StreamController<Object>.broadcast();
  StreamSubscription? _sub;

  @override
  Future<void> connect(String ipAddress, int port) async {
    final ctrlUri = Uri(scheme: 'ws', host: ipAddress, port: port, path: '/');
    final videoUri = Uri(scheme: 'ws', host: ipAddress, port: 82, path: '/video');

    try {
      _ctrlWSClient.setEndpoint(ctrlUri);
      _videoWSClient.setEndpoint(videoUri);
      await _ctrlWSClient.connect();
      await Future.delayed(const Duration(milliseconds: 300));
      await _videoWSClient.connect();
      await _sub?.cancel();
      _sub = _ctrlWSClient.messages?.listen(
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
    await _ctrlWSClient.disconnect();
  }

  @override
  bool get isConnected => _ctrlWSClient.isConnected;

  @override
  Stream<Object> errors() => _errorCtrl.stream;
}
