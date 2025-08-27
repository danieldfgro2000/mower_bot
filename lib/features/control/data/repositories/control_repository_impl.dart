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
  StreamSubscription<Map<String, dynamic>>? _jsonStringSubscription;

  ControlRepositoryImpl({
    required IWebSocketClient controlWebSocketClient,
    required IWebSocketClient videoWebSocketClient,
  })
      :_videoWebSocketClient = videoWebSocketClient,
        _controlWebSocketClient = controlWebSocketClient {
    _videoStreamCtrl = StreamController<Uint8List>.broadcast();
  }

  @override
  bool get isConnected => _controlWebSocketClient.isConnected;

  @override
  Stream<Uint8List> get videFrames => _videoStreamCtrl.stream;

  @override
  Future<void> startVideoStream(int fps) async {
    if(!_controlWebSocketClient.isConnected) {
      await _controlWebSocketClient.connect();
    }
    if(!_videoWebSocketClient.isConnected) {
      await _videoWebSocketClient.connect();
    }

    _webSocketListenMessage();
    
    _videoCmdSend('start', fps: fps);
  }

  @override
  Future<void> stopVideoStream() async {
    if (!isConnected) {
      debugPrint('[WebSocket] is not connected');
      return;
    }

    _videoCmdSend('stop');

    await _detachListeners();
  }

  Future<void> _detachListeners() async {
    await _binarySubscription?.cancel();
    await _jsonStringSubscription?.cancel();
    _binarySubscription = null;
    _jsonStringSubscription = null;
  }

  void _videoCmdSend(String cmd, {int? fps}) {
    _controlWebSocketClient.send(
      MessageEnvelope(
        topic: MessageTopic.camera,
        data: {'cmd': cmd, 'fps': fps},
      ).toJson(),
    );
  }

  Future<void> _webSocketListenMessage() async {
    await _jsonStringSubscription?.cancel();
    _jsonStringSubscription = _controlWebSocketClient.messages?.listen((jsonString) {
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
    _binarySubscription = _videoWebSocketClient.binary?.listen(
          (bytes) {
        if (!_videoStreamCtrl.isClosed) _videoStreamCtrl.add(bytes);
      },
      onError: (e, st) => debugPrint('[WebSocket] binary stream error: $e\n$st'),
    );
  }

  Future <void> dispose() async {
    await _detachListeners();
    _controlWebSocketClient.disconnect();
    _videoWebSocketClient.disconnect();
    if (!_videoStreamCtrl.isClosed) _videoStreamCtrl.close();
  }
}
