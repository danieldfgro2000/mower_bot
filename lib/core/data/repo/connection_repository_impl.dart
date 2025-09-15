import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/di/injection_container.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

enum MowerWsPort {
  ctrl(85),
  video(81);

  final int port;
  const MowerWsPort(this.port);
}

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
  final IWebSocketClient _ctrlWSClient = sl<IWebSocketClient>(instanceName: 'ctrl');

  @override
  Stream<Map<String, dynamic>>? jsonStream() => _ctrlWSClient.messages;

  final _errorCtrl = StreamController<Object>.broadcast();
  StreamSubscription? _ctrlErrSub;

  @override
  Future<void> connectCtrlWs(String ipAddress) async {
    final ctrlUri = Uri(scheme: 'ws', host: ipAddress, port: MowerWsPort.ctrl.port, path: '/');

    try {
      _ctrlWSClient.setEndpoint(ctrlUri);

      await _ctrlWSClient.connect();
      await _ctrlErrSub?.cancel();

      _ctrlErrSub = _ctrlWSClient.messages.listen(
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
  bool get isCtrlWsConnected => _ctrlWSClient.isConnected;

  @override
  Stream<Object> ctrlWsErr() => _errorCtrl.stream;

  @override
  Stream<ConnectionStatus>? ctrlWsConnected() =>  _ctrlWSClient.connectionChanged;
}
