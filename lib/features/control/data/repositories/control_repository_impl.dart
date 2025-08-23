import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:mower_bot/core/network/message_envelope.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class ControlRepositoryImpl implements ControlRepository {
  final IWebSocketClient _webSocketClient;
  late final StreamController<Uint8List> _videoStreamCtrl;
  StreamSubscription<Uint8List>? _binarySubscription;
  StreamSubscription<Map<String, dynamic>>? _jsonStringSubscription;

  ControlRepositoryImpl(this._webSocketClient) {
    _videoStreamCtrl = StreamController<Uint8List>.broadcast();
  }

  @override
  bool get isConnected => _webSocketClient.isConnected;

  @override
  Stream<Uint8List> get videFrames => _videoStreamCtrl.stream;

  @override
  Future<void> startVideoStream(int fps) async {
    if (!isConnected) {
      debugPrint('[WebSocket] is not connected');
      return;
    }
    _videoCmdSend('start', fps: fps);
    _webSocketListenMessage();
  }

  @override
  Future<void> stopVideoStream() async {
    if (!isConnected) {
      debugPrint('[WebSocket] is not connected');
      return;
    }

    _videoCmdSend('stop');

    await _binarySubscription?.cancel();
    await _jsonStringSubscription?.cancel();
  }

  void _videoCmdSend(String cmd, {int? fps}) {
    _webSocketClient.send(
      MessageEnvelope(
        topic: MessageTopic.camera,
        data: {'cmd': cmd, 'fps': fps},
      ).toJson(),
    );
  }

  Future<void> _webSocketListenMessage() async {
    await _jsonStringSubscription?.cancel();
    _jsonStringSubscription = _webSocketClient.messages.listen((jsonString) {
      try {
        final envelope = MessageEnvelope.fromJson(jsonString);
        switch (envelope.topic) {
          case MessageTopic.camera:
            debugPrint('Received camera message: ${envelope.data}');
            break;
          default:
            break;
        }
      } catch (e) {
        debugPrint('Error parsing message envelope: $e');
        return;
      }
    });

    await _binarySubscription?.cancel();
    _binarySubscription = _webSocketClient.binary.listen(
          (bytes) {
        if (!_videoStreamCtrl.isClosed) _videoStreamCtrl.add(bytes);
      },
      onError: (e, st) => debugPrint('[WebSocket] binary stream error: $e\n$st'),
    );
  }
}
