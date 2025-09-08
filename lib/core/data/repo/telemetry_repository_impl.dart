import 'dart:async';

import 'package:mower_bot/core/data/dto/mower_status_dto.dart';
import 'package:mower_bot/core/data/dto/telemetry_data_dto.dart';
import 'package:mower_bot/core/data/network/message_envelope.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class TelemetryRepositoryImpl implements TelemetryRepository {
  final IWebSocketClient _webSocketClient;
  late final StreamController<TelemetryDataModel> _telemetryDataCtrl;
  late final StreamController<MowerStatusModel> _mowerStatusCtrl;

  TelemetryRepositoryImpl(this._webSocketClient) {
    _telemetryDataCtrl = StreamController<TelemetryDataModel>.broadcast();
    _mowerStatusCtrl = StreamController<MowerStatusModel>.broadcast();
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
          _mowerStatusCtrl.add(MowerStatusMapper.fromData(envelope.data['telemetry'] ?? {}));
          break;
        default:
          break;
      }
    });
  }

  @override
  Stream<TelemetryDataModel> observeTelemetry() => _telemetryDataCtrl.stream;

  @override
  Stream<MowerStatusModel> observeMowerStatus() => _mowerStatusCtrl.stream;
}