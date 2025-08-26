import 'dart:async';

import 'package:mower_bot/core/network/message_envelope.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/domain/entity/mower_status_entity.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class TelemetryRepositoryImpl implements TelemetryRepository {
  final IWebSocketClient _webSocketClient;
  late final StreamController<TelemetryEntity> _telemetryDataCtrl;
  late final StreamController<MowerStatusEntity> _telemetryStatusCtrl;

  TelemetryRepositoryImpl(this._webSocketClient) {
    _telemetryDataCtrl = StreamController<TelemetryEntity>.broadcast();
    _telemetryStatusCtrl = StreamController<MowerStatusEntity>.broadcast();
  }

  @override
  bool get isConnected => _webSocketClient.isConnected;


  @override
  Future<void> startTelemetry() async {
    print('Starting telemetry stream... is connected: $isConnected');
    if(!isConnected) {
      throw Exception('WebSocket is not connected');
    }
    _webSocketClient.messages?.listen((raw) {
      final envelope = MessageEnvelope.fromJson(raw);

        // print('Received telemetry data envelope: ${envelope.data}');

      switch (envelope.topic) {
        case MessageTopic.telemetry:
          _telemetryDataCtrl.add(TelemetryMapper.fromData(envelope.data));
          break;
        case MessageTopic.status:
          _telemetryStatusCtrl.add(MowerStatusMapper.fromData(envelope.data['telemetry'] ?? {}));
          break;
        default:
          break;
      }
    });
  }

  @override
  Stream<TelemetryEntity> observeTelemetry() => _telemetryDataCtrl.stream;

  @override
  Stream<MowerStatusEntity> observeTelemetryStatus() => _telemetryStatusCtrl.stream;
}