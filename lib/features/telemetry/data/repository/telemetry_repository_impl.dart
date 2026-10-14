import 'dart:async';

import 'package:mower_bot/core/data/network/message_envelope.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/device/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/data/dto/mower_status_dto.dart';
import 'package:mower_bot/features/telemetry/data/dto/telemetry_data_dto.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class TelemetryRepositoryImpl implements TelemetryRepository {
  final IWebSocketClient _webSocketClient;
  late final StreamController<TelemetryDataModel> _telemetryDataCtrl;
  late final StreamController<MowerStatusModel> _mowerStatusCtrl;
  StreamSubscription<JsonMap>? _messageSubscription;

  TelemetryRepositoryImpl(this._webSocketClient) {
    _telemetryDataCtrl = StreamController<TelemetryDataModel>.broadcast();
    _mowerStatusCtrl = StreamController<MowerStatusModel>.broadcast();
  }

  @override
  bool get isConnected => _webSocketClient.isConnected;

  @override
  Future<void> startTelemetry() async {
    if (!isConnected) {
      throw Exception('WebSocket is not connected');
    }
    _messageSubscription ??= _webSocketClient.messages.listen((raw) {
      final envelope = MessageEnvelope.fromJson(raw);
      switch (envelope.topic) {
        case MessageTopic.telemetry:
          _telemetryDataCtrl.add(TelemetryMapper.fromData(envelope.data));
          break;
        case MessageTopic.status:
          _mowerStatusCtrl.add(
            MowerStatusMapper.fromData(envelope.data['telemetry'] ?? {}),
          );
          break;
        default:
          break;
      }
    });
  }

  @override
  Future<void> stopTelemetry() async {
    final subscription = _messageSubscription;
    _messageSubscription = null;
    await subscription?.cancel();
  }

  @override
  Future<void> dispose() async {
    await stopTelemetry();
    await _telemetryDataCtrl.close();
    await _mowerStatusCtrl.close();
  }

  @override
  Stream<TelemetryDataModel> observeTelemetry() => _telemetryDataCtrl.stream;

  @override
  Stream<MowerStatusModel> observeMowerStatus() => _mowerStatusCtrl.stream;
}
