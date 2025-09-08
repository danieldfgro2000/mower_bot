import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mower_bot/core/data/network/message_envelope.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class ControlRepositoryImpl implements ControlRepository {
  final IWebSocketClient _controlWebSocketClient; // WS://IP:81 (JSON)

  ControlRepositoryImpl({
    required IWebSocketClient controlWebSocketClient,
    required IWebSocketClient binaryWebSocketClient,
  }) : _controlWebSocketClient = controlWebSocketClient;

  @override
  bool get isCtrlWsConnected => _controlWebSocketClient.isConnected;

  @override
  String? get videoStreamUrl {
    final Uri? uri = _controlWebSocketClient.endpoint;
    if (uri == null) return null;

    return 'http://${uri.host}';
  }

  @override
  Future<void> sendDriveCommand(Map<String, dynamic> command) async {
    if (!isCtrlWsConnected) {
      throw Exception('Control WebSocket is not connected');
    }
    final envelope = MessageEnvelope(
      topic: MessageTopic.drive,
      data: command,
    );
    debugPrint('Sending drive command: ${envelope.toJson()}');
    _controlWebSocketClient.send(envelope.toJson());
  }
}