import 'dart:async';
import 'dart:typed_data';

import 'package:mower_bot/core/network/message_envelope.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class ControlRepositoryImpl implements ControlRepository{
  final IWebSocketClient _webSocketClient;
  late final StreamController<Uint8List> _videoStreamCtrl;

  ControlRepositoryImpl(this._webSocketClient) {
    _videoStreamCtrl = StreamController<Uint8List>.broadcast();
  }

  @override
  bool get isConnected => _webSocketClient.isConnected;

  @override
  Stream<Uint8List> get videFrames => _videoStreamCtrl.stream;

  @override
  Future<void> startVideoStream() async {
    if (!isConnected) throw Exception('WebSocket is not connected');

    _webSocketClient.messages.listen((raw) {
      final envelope = MessageEnvelope.fromJson(raw);
      switch (envelope.topic) {
        case MessageTopic.camera:
          _videoStreamCtrl.add(Uint8List.fromList(List<int>.from(envelope.data['frame'] ?? [])));
          break;
        default:
          _videoStreamCtrl.add(Uint8List.fromList(List<int>.from(envelope.data['frame'] ?? [])));
          break;
      }
    });
  }
}