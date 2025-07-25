import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageHandler = void Function(Map<String, dynamic> message);

class WebSocketClient {
  // WebSocketChannel? _channel;
  // Stream<dynamic>? _stream;
  //
  // void connect(String uri) {
  //   _channel = WebSocketChannel.connect(Uri.parse(uri));
  //   _stream = _channel?.stream;
  // }
  //
  // void send(Map<String, dynamic> message) {
  //   _channel?.sink.add(message);
  // }
  //
  // Stream<dynamic>? get messages => _stream;
  // void disconnect() => _channel?.sink.close();
  final _controller = StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get messages => _controller.stream;

  void send(Map<String, dynamic> message) {
    // In a real implementation, this would send the message over the WebSocket
    // For demo purposes, we just print it
    print("Sending: $message");
  }
  // For demo: simulate mower telemetry every 2 seconds
  void connectDummy(){
    double driftX = 0.0;
    double driftY = 0.0;
    Timer.periodic(const Duration(seconds: 2), (timer) {
      driftX += (0.05 - 01 * (timer.tick % 2));
      driftY += 0.02;

      final data = {
        "battery": 12.3,
        "heading": 180.0 + (timer.tick % 360),
        "encoderSpeed": 1.5,
        "event": timer.tick % 5 == 0 ? "telemetry" : "lap_completed",
        "isMoving": timer.tick % 20 == 0,
        "driftX": driftX,
        "driftY": driftY,
        "headingError": 0.1 * (timer.tick % 10),
      };
      _controller.add(data);
    });
  }
}