import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/message_envelope.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/core/network/websocket_config.dart';
import 'package:mower_bot/features/telemetry/data/models/telemetry_model.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class TelemetryRemoteDataSource {
  Stream<TelemetryModel> observeTelemetry();
  Future<void> connect(Uri uri);
  Future<void> disconnect();
  bool get isConnected;
}

class TelemetryRemoteDataSourceImpl implements TelemetryRemoteDataSource {
  final IWebSocketClient _webSocketClient;
  final WebSocketConfig _webSocketConfig;

  late final StreamController<TelemetryModel> _telemetryCtrl;
  StreamSubscription? _rawSub;

  TelemetryRemoteDataSourceImpl(this._webSocketClient, this._webSocketConfig);
  @override
  Stream<TelemetryModel> observeTelemetry() => _telemetryCtrl.stream;


  @override
  Future<void> connect(Uri uri) async {
    await _webSocketClient.connect(uri);

    _rawSub?.cancel();
    _rawSub = _webSocketClient.messages.listen((raw) {
      final envelope = MessageEnvelope.fromJson(raw);

      switch (envelope.topic) {
        case MessageTopic.telemetry:
          try {
            final telemetry = TelemetryModel.fromJson(envelope.data);
            _telemetryCtrl.add(telemetry);
          } catch (e) {
            if (kDebugMode) print('Error parsing telemetry data: $e');
          }
          break;
        default:
          if (kDebugMode) print('Unknown topic: ${envelope.topic}');
      }
    }, onError: (e, st) {
      if (kDebugMode) print('Error in telemetry stream: $e');
      _telemetryCtrl.addError(e, st);
    }, onDone: () {
      if (kDebugMode) print('Telemetry stream closed');
      _telemetryCtrl.close();
    });

  }

  @override
  Future<void> disconnect() async {
    await _webSocketClient.disconnect();
    await _rawSub?.cancel();
  }

  @override
  bool get isConnected => _webSocketClient.isConnected;


  //
  // @override
  // Stream<TelemetryModel> observeTelemetry(Uri wsUrl) async* {
  //   try {
  //     await _webSocketClient.connect(wsUrl);
  //     await for (final message in _webSocketClient.messages) {
  //       // print('Received telemetry message: $message');
  //
  //       if (!_isTelemetryMessage(message)) {
  //         // if (kDebugMode) print('Ignoring non-telemetry message: $message');
  //         continue;
  //       }
  //       try {
  //         yield TelemetryModel.fromJson(message);
  //       } catch (e) {
  //         if (kDebugMode) print('Error parsing telemetry message: $e');
  //         continue;
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) print('WebSocket connection error: $e');
  //     yield* Stream.error(e);
  //   }
  // }
  //
  // bool _isTelemetryMessage(Map<String, dynamic> m) {
  //   final t = m['type'];
  //   if (t is String && t.toLowerCase() == 'telemetry') {
  //     return true;
  //   }
  //   return false;
  // }
}

class WebSocketService {
  final String url;

  WebSocketService(this.url);

  WebSocketChannel connect() {
    if(kDebugMode) print('Connecting to WebSocket: $url');
    return WebSocketChannel.connect(Uri.parse(url));
  }
}