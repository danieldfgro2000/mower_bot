import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/telemetry/data/models/telemetry_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class TelemetryRemoteDataSource {
  Stream<TelemetryModel> streamTelemetry(Uri wsUrl);
}

class TelemetryRemoteDataSourceImpl implements TelemetryRemoteDataSource {
  final IWebSocketClient _webSocketClient;
  TelemetryRemoteDataSourceImpl(this._webSocketClient);

  @override
  Stream<TelemetryModel> streamTelemetry(Uri wsUrl) async* {
    try {
      await _webSocketClient.connect(wsUrl);
      await for (final message in _webSocketClient.messages) {
        print('Received telemetry message: $message');
        try {
          yield TelemetryModel.fromJson(message);
        } catch (e) {
          if (kDebugMode) print('Error parsing telemetry message: $e');
          continue;
        }
      }
    } catch (e) {
      if (kDebugMode) print('WebSocket connection error: $e');
      yield* Stream.error(e);
    }
  }
}

class WebSocketService {
  final String url;

  WebSocketService(this.url);

  WebSocketChannel connect() {
    if(kDebugMode) print('Connecting to WebSocket: $url');
    return WebSocketChannel.connect(Uri.parse(url));
  }
}