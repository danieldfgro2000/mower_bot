import 'package:flutter/cupertino.dart';

@immutable
class WebSocketConfig {
  final Duration ping3sec;
  final Duration timeout3sec;
  final Duration retry100millis;
  final Duration retry300millis;
  final int max5attempts;

  const WebSocketConfig({
    this.ping3sec = const Duration(seconds: 3),
    this.timeout3sec = const Duration(seconds: 3),
    this.retry100millis = const Duration(milliseconds: 100),
    this.retry300millis = const Duration(milliseconds: 300),
    this.max5attempts = 5,
  });
}