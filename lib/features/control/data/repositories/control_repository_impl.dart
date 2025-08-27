import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:mower_bot/core/network/message_envelope.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class ControlRepositoryImpl implements ControlRepository {
  final IWebSocketClient _controlWebSocketClient; // WS://IP:81 (JSON)
  final IWebSocketClient _videoWebSocketClient; // WS://IP:82 (binary)

  late final StreamController<Uint8List> _videoStreamCtrl;
  StreamSubscription<Uint8List>? _binarySubscription;

  ControlRepositoryImpl({
    required IWebSocketClient controlWebSocketClient,
    required IWebSocketClient videoWebSocketClient,
  }) : _videoWebSocketClient = videoWebSocketClient,
       _controlWebSocketClient = controlWebSocketClient {
    _videoStreamCtrl = StreamController<Uint8List>.broadcast();
  }

  @override
  bool get isVideoWsConnected => _videoWebSocketClient.isConnected;

  @override
  bool get isCtrlWsConnected => _controlWebSocketClient.isConnected;


  @override
  Stream<Uint8List> get videFrames => _videoStreamCtrl.stream;

  @override
  Future<void> startVideoStream(int fps) async {

    if(!_videoWebSocketClient.isConnected) {
      await _videoWebSocketClient.connect();
    }

    _webSocketListenMessage();
    
    _videoCmdSend('start', fps: fps);
  }

  Future<void> _webSocketListenMessage() async {
    await _binarySubscription?.cancel();
    _binarySubscription = _videoWebSocketClient.binary?.listen(
      (bytes) {
        _videoStreamCtrl.add(bytes);
      },
      onError: (e, st) =>
          debugPrint('[WebSocket] binary stream error: $e\n$st'),
    );
  }

  void _videoCmdSend(String cmd, {int? fps}) {
    _controlWebSocketClient.send(
      MessageEnvelope(
        topic: MessageTopic.camera,
        data: {'cmd': cmd, 'fps': fps},
      ).toJson(),
    );
  }

  @override
  Future<void> stopVideoStream() async {
    if (!isVideoWsConnected) {
      debugPrint('[WebSocket] is not connected');
      return;
    }

    _videoCmdSend('stop');

    await _detachListeners();
  }

  Future<void> _detachListeners() async {
    await _binarySubscription?.cancel();
    _binarySubscription = null;
  }
}