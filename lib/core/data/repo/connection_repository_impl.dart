import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/error/error.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

enum MowerWsPort {
  ctrl(85),
  video(81);

  final int port;
  const MowerWsPort(this.port);
}

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
  // Inject dependencies via constructor to avoid service locator usage inside implementation
  final IWebSocketClient _ctrlWSClient;
  final ExceptionHandler _exceptionHandler = ExceptionHandler();

  MowerConnectionRepositoryImpl(this._ctrlWSClient);

  @override
  Stream<Map<String, dynamic>>? jsonStream() => _ctrlWSClient.messages;

  final _errorCtrl = StreamController<AppException>.broadcast();
  StreamSubscription? _ctrlErrSub;

  @override
  Future<void> connectCtrlWs(String ipAddress, int port) async {
    if (ipAddress.isEmpty) {
      throw ValidationException.required('IP Address');
    }

    final ctrlUri = Uri(scheme: 'ws', host: ipAddress, port: port, path: '/');

    try {
      _ctrlWSClient.setEndpoint(ctrlUri);

      await _ctrlWSClient.connect();
      await _ctrlErrSub?.cancel();

      _ctrlErrSub = _ctrlWSClient.messages.listen(
        (_) {},
        onError: (e, st) {
          final appException = _exceptionHandler.handleException(e, st);
          _errorCtrl.add(appException);
        },
      );

    } catch (e, stackTrace) {
      final exception = _exceptionHandler.handleException(e, stackTrace);
      if (kDebugMode) print('Connection failed: ${exception.message}');
      throw exception;
    }
  }

  @override
  Future<void> disconnectCtrlWs() async {
    try {
      await _ctrlErrSub?.cancel();
      await _ctrlWSClient.disconnect();
    } catch (e, stackTrace) {
      final exception = _exceptionHandler.handleException(e, stackTrace);
      if (kDebugMode) print('Disconnect failed: ${exception.message}');
      throw exception;
    }
  }

  @override
  bool get isCtrlWsConnected => _ctrlWSClient.isConnected;

  @override
  Stream<AppException> ctrlWsErr() => _errorCtrl.stream;

  @override
  Stream<ConnectionStatus>? ctrlWsConnected() => _ctrlWSClient.connectionChanged;

  void dispose() {
    _errorCtrl.close();
    _exceptionHandler.dispose();
  }
}
