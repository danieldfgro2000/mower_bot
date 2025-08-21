import 'dart:async';

import 'package:mower_bot/core/network/message_envelope.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class TelemetryRepositoryImpl implements TelemetryRepository {
  final IWebSocketClient _webSocketClient;
  late final StreamController<TelemetryEntity> _telemetryCtrl;

  TelemetryRepositoryImpl(this._webSocketClient) {
    _telemetryCtrl = StreamController<TelemetryEntity>.broadcast();
  }

  @override
  bool get isConnected => _webSocketClient.isConnected;


  @override
  Future<void> startTelemetry() async {
    print('Starting telemetry stream... is connected: $isConnected');
    if(!isConnected) {
      throw Exception('WebSocket is not connected');
    }
    _webSocketClient.messages.listen((raw) {
      final envelope = MessageEnvelope.fromJson(raw);

      if(envelope.topic == MessageTopic.telemetry) {
        _telemetryCtrl.add(TelemetryMapper.fromData(envelope.data));
      }
    });
  }

  @override
  Stream<TelemetryEntity> observeTelemetry() => _telemetryCtrl.stream;
}