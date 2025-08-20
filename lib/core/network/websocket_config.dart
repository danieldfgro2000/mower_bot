import 'package:flutter/cupertino.dart';

@immutable
class WebSocketConfig {
  final Duration pingInterval;
  final Duration reconnectMinDelay;
  final Duration reconnectMaxDelay;
  final int maxReconnectAttempts;

  const WebSocketConfig({
    this.pingInterval = const Duration(seconds: 30),
    this.reconnectMinDelay = const Duration(seconds: 1),
    this.reconnectMaxDelay = const Duration(seconds: 10),
    this.maxReconnectAttempts = 5,
  });
}