import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_ctrl_ws_connected_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/stream_connection_status_use_case.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class _FakeConnectionRepo implements MowerConnectionRepository {
  bool _isConnected = false;
  String? lastIp;
  int? lastPort;
  final _connectedCtrl = StreamController<ConnectionStatus>.broadcast();

  @override
  Stream<Map<String, dynamic>>? jsonStream() => null;

  @override
  Stream<AppException> ctrlWsErr() => const Stream<AppException>.empty();

  @override
  Stream<ConnectionStatus>? ctrlWsConnected() => _connectedCtrl.stream;

  @override
  Future<void> connectCtrlWs(String ipAddress, int port) async {
    lastIp = ipAddress;
    lastPort = port;
    _isConnected = true;
    _connectedCtrl.add(ConnectionStatus.ctrlWsConnected);
  }

  @override
  Future<void> disconnectCtrlWs() async {
    _isConnected = false;
    _connectedCtrl.add(ConnectionStatus.disconnected);
  }

  @override
  bool get isCtrlWsConnected => _isConnected;

  Future<void> dispose() async {
    await _connectedCtrl.close();
  }
}

void main() {
  group('Ctrl websocket usecases', () {
    test('ConnectToCtrlWsUseCase forwards ip/port', () async {
      final repo = _FakeConnectionRepo();
      final usecase = ConnectToCtrlWsUseCase(repo);

      await usecase('10.0.0.42', 85);

      expect(repo.lastIp, '10.0.0.42');
      expect(repo.lastPort, 85);
      await repo.dispose();
    });

    test('DisconnectCtrlWsUseCase calls disconnect', () async {
      final repo = _FakeConnectionRepo();
      final connect = ConnectToCtrlWsUseCase(repo);
      final disconnect = DisconnectCtrlWsUseCase(repo);

      await connect('10.0.0.42', 85);
      expect(repo.isCtrlWsConnected, isTrue);

      await disconnect();
      expect(repo.isCtrlWsConnected, isFalse);
      await repo.dispose();
    });

    test('CheckCtrlWsConnectedUseCase reflects repository state', () async {
      final repo = _FakeConnectionRepo();
      final connect = ConnectToCtrlWsUseCase(repo);
      final check = CheckCtrlWsConnectedUseCase(repo);

      expect(check(), isFalse);
      await connect('10.0.0.42', 85);
      expect(check(), isTrue);
      await repo.dispose();
    });

    test('StreamConnectionStatusUseCase streams through from repository', () async {
      final repo = _FakeConnectionRepo();
      final connect = ConnectToCtrlWsUseCase(repo);
      final disconnect = DisconnectCtrlWsUseCase(repo);
      final streamUsecase = StreamConnectionStatusUseCase(repo);

      final events = <ConnectionStatus>[];
      final sub = streamUsecase()!.listen(events.add);

      await connect('10.0.0.42', 85);
      await disconnect();

      await Future<void>.delayed(Duration.zero);

      expect(events, containsAllInOrder(<ConnectionStatus>[
        ConnectionStatus.ctrlWsConnected,
        ConnectionStatus.disconnected,
      ]));

      await sub.cancel();
      await repo.dispose();
    });
  });
}
