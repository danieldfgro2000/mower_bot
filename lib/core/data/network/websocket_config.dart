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
    this.pingInterval = const Duration(seconds: 10),
    this.connectProbeTimeout = const Duration(seconds: 10),
    this.reconnectMinDelay = const Duration(milliseconds: 100),
    this.reconnectMaxDelay = const Duration(milliseconds: 300),
    this.autoReconnect = true,
    this.maxReconnectAttempts = 5,
  });
}