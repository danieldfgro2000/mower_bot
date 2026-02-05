import 'package:flutter/cupertino.dart';

@immutable
class WebSocketConfig {
  final Duration ping3sec;
  final Duration timeout3sec;
  final Duration retry1sec;
  final Duration retry5sec;
  final int max5attempts;
  final bool enableReachability;

  const WebSocketConfig({
    this.ping3sec = const Duration(seconds: 3),
    this.timeout3sec = const Duration(seconds: 3),
    this.retry1sec = const Duration(seconds: 1),
    this.retry5sec = const Duration(seconds: 5),
    this.max5attempts = 5,
    this.enableReachability = true,
  });
}