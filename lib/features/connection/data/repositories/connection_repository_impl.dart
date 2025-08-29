import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/di/injection_container.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

enum MowerWsPort {
  ctrl(81),
  video(82);

  final int port;
  const MowerWsPort(this.port);
}

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
  final IWebSocketClient _ctrlWSClient = sl<IWebSocketClient>(instanceName: 'ctrl');
  final IWebSocketClient _videoWSClient = sl<IWebSocketClient>(instanceName: 'video');

  @override
  Stream<Map<String, dynamic>>? jsonStream() => _ctrlWSClient.messages;

  @override
  Stream<Uint8List>? videoStream() => _videoWSClient.binary;

  final _errorCtrl = StreamController<Object>.broadcast();
  final _errorVideo = StreamController<Object>.broadcast();
  StreamSubscription? _ctrlErrSub;
  StreamSubscription? _videoErrSub;

  @override
  Future<void> connectCtrlWs(String ipAddress) async {
    final ctrlUri = Uri(scheme: 'ws', host: ipAddress, port: MowerWsPort.ctrl.port, path: '/');
    final videoUri = Uri(scheme: 'ws', host: ipAddress, port: MowerWsPort.ctrl.port, path: '/');

    try {
      _ctrlWSClient.setEndpoint(ctrlUri);
      _videoWSClient.setEndpoint(videoUri);

      await _ctrlWSClient.connect();
      await _ctrlErrSub?.cancel();

      _ctrlErrSub = _ctrlWSClient.messages?.listen(
        (_) {},
        onError: (e, st) => _errorCtrl.add(st),
      );

    } catch (e) {
      if (kDebugMode) print('Connection failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> connectVideoWs(String ipAddress) async {
    try {
      await _videoWSClient.connect();
      await _videoErrSub?.cancel();

      _videoErrSub = _videoWSClient.binary?.listen(
        (_) {},
        onError: (e, st) => _errorCtrl.add(st),
      );
    } catch (e) {
      if (kDebugMode) print('Connection failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnectCtrlWs() async {
    await _ctrlErrSub?.cancel();
    await _ctrlWSClient.disconnect();
  }

  @override
  Future<void> disconnectVideoWs() async {
    await _videoErrSub?.cancel();
    await _videoWSClient.disconnect();
  }


  @override
  bool get isCtrlWsConnected => _ctrlWSClient.isConnected;

  @override
  bool get isVideoWsConnected => _videoWSClient.isConnected;


  @override
  Stream<Object> ctrlWsErr() => _errorCtrl.stream;

  @override
  Stream<Object> videoWsErr() => _errorVideo.stream;

  @override
  Stream<bool> ctrlWsConnected() =>
      Stream.periodic(
          const Duration(seconds: 1), (_) =>
      isCtrlWsConnected).distinct();

  @override
  Stream<bool> videoWsConnected() =>
      Stream.periodic(
          const Duration(seconds: 1), (_) =>
      isVideoWsConnected).distinct();
}
