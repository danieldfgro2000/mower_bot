import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_ctrl_ws_connected_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class MowerConnectionBloc
    extends Bloc<MowerConnectionEvent, MowerConnectionState> {
  final ConnectToCtrlWsUseCase connectToCtrlWsUseCase;
  final DisconnectCtrlWsUseCase disconnectCtrlWsUseCase;
  final CheckCtrlWsConnectedUseCase checkCtrlWsConnectedUseCase;
  final TelemetryBloc telemetryBloc;
  final MowerConnectionRepository repo;
  StreamSubscription? _errSub;
  StreamSubscription? _connectionStatusSub;

  MowerConnectionBloc(
    this.connectToCtrlWsUseCase,
    this.disconnectCtrlWsUseCase,
    this.checkCtrlWsConnectedUseCase,
    this.telemetryBloc,
    this.repo,
  ) : super(const MowerConnectionState()) {
    on<ChangeIp>(_onChangeIp);
    on<ConnectToMower>(_onConnect);
    on<DisconnectFromMower>(_onDisconnect);
    on<CheckConnectionStatus>(_onCheckConnection);
    on<ConnectionChanged>(_onConnectionChanged);
    on<ConnectionError>(_onConnectionError);
  }

  void _onChangeIp(event, emit) {
    emit(state.copyWith(ip: event.ipAddress));
  }

  FutureOr<void> _onConnect(event, emit) async {
    emit(state.copyWith(status: ConnectionStatus.connecting));

    try {
      if(state.ip == null || state.ip!.isEmpty) {
        throw Exception('IP address is required');
      }
      await connectToCtrlWsUseCase(state.ip!);
      await _errSub?.cancel();
      _errSub = repo.ctrlWsErr().listen((e) => add(ConnectionError(e.toString())));
      emit(state.copyWith(status: ConnectionStatus.ctrlWsConnected));
      _connectionStatusSub?.cancel();
      _connectionStatusSub = repo.ctrlWsConnected()?.listen(
        (isConnected) {
          add(ConnectionChanged(isCtrlWsConnected: isConnected));
          isConnected
            ? telemetryBloc.add(StartTelemetry())
            : telemetryBloc.add(StopTelemetry());
        },
      );
    } catch (e) {
      emit(state.copyWith(status: ConnectionStatus.error, error: e.toString()));
      return;
    }
  }

  FutureOr<void> _onDisconnect(event, emit) async {
    await _errSub?.cancel();
    await disconnectCtrlWsUseCase();
    emit(state.copyWith(status: ConnectionStatus.disconnected));
  }

  void _onCheckConnection(event, emit) async {
    try {
      final isConnected = checkCtrlWsConnectedUseCase();
      emit(state.copyWith(
        status: isConnected
          ? ConnectionStatus.ctrlWsConnected
          : ConnectionStatus.disconnected,
      ));
    } catch (e) {
      emit(state.copyWith(status: ConnectionStatus.error, error: e.toString()));
    }
  }

  void _onConnectionChanged(event, emit) async {
    emit(state.copyWith(
      status: event.isCtrlWsConnected == true
        ? ConnectionStatus.ctrlWsConnected
        : event.isVideoWsConnected == true
          ? ConnectionStatus.videoWsConnected
          : ConnectionStatus.disconnected,
    ));
  }

  void _onConnectionError(event, emit) async {
    emit(state.copyWith(error: event.error));
  }
}
