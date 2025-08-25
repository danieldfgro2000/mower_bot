import 'package:flutter/cupertino.dart';

@immutable
class WebSocketConfig {
  final Duration pingInterval;
  final Duration connectProbeTimeout;
  final Duration reconnectMinDelay;
  final Duration reconnectMaxDelay;
  final bool autoReconnect;
  final int maxReconnectAttempts;

  const WebSocketConfig({
    this.pingInterval = const Duration(seconds: 30),
    this.connectProbeTimeout = const Duration(seconds: 3),
    this.reconnectMinDelay = const Duration(seconds: 5),
    this.reconnectMaxDelay = const Duration(seconds: 10),
    this.autoReconnect = true,
    this.maxReconnectAttempts = 5,
  });
}