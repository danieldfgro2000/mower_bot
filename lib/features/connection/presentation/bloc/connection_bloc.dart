import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/error/error.dart';
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
  final ExceptionHandler _exceptionHandler = ExceptionHandler();
  final ErrorMapper _errorMapper = ErrorMapper();

  StreamSubscription? _errSub;
  StreamSubscription? _connectionStatusSub;

  MowerConnectionBloc(this.connectToCtrlWsUseCase,
      this.disconnectCtrlWsUseCase,
      this.checkCtrlWsConnectedUseCase,
      this.telemetryBloc,
      this.repo,) : super(const MowerConnectionState()) {
    on<ChangeIp>(_onChangeIp);
    on<ChangePort>(_onChangePort);
    on<ConnectToMower>(_onConnect);
    on<DisconnectFromMower>(_onDisconnect);
    on<CheckConnectionStatus>(_onCheckConnection);
    on<ConnectionChanged>(_onConnectionChanged);
    on<ConnectionError>(_onConnectionError);

    // Initialize connection status listener on startup
    _initializeConnectionStatus();
  }

  void _initializeConnectionStatus() {
    // Check current connection status
    add(CheckConnectionStatus());

    // Tear down any stale subscription and re-subscribe for fresh updates
    _connectionStatusSub ??= repo.ctrlWsConnected()?.listen(
          (connectionStatus) {
        add(ConnectionChanged(connectionStatus: connectionStatus));
        connectionStatus == ConnectionStatus.ctrlWsConnected
            ? telemetryBloc.add(StartTelemetry())
            : telemetryBloc.add(StopTelemetry());
      },
      onDone: () {
        // Stream closed by repo, reset so a future call will re-subscribe
        _connectionStatusSub = null;
        add(CheckConnectionStatus());
      },
      cancelOnError: false,
    );
  }

  void _onChangeIp(event, emit) {
    emit(state.copyWith(ip: event.ipAddress));
  }

  void _onChangePort(event, emit) {
    emit(state.copyWith(port: event.port));
  }

  FutureOr<void> _onConnect(event, emit) async {
    emit(state.copyWith(status: ConnectionStatus.connecting));

    // Recreate the connection status listener to avoid being stuck with a completed/closed sub
    await _connectionStatusSub?.cancel();
    _connectionStatusSub = null;
    _initializeConnectionStatus();

    final result = await _exceptionHandler.safeExecute(() async {
      if (state.ip == null || state.ip!.isEmpty) {
        throw ValidationException.required('IP Address');
      }
      if (state.port == null || state.port! <= 0) {
        throw ValidationException.required('Port');
      }

      await connectToCtrlWsUseCase(state.ip!, state.port!);

      // After initiating the connection, double-check current status
      add(CheckConnectionStatus());

      // Set up error listener
      await _errSub?.cancel();
      _errSub = repo.ctrlWsErr().listen((exception) {
        final userMessage = _errorMapper.mapExceptionToMessage(exception);
        add(ConnectionError(userMessage));
      });
    });

    if (result == null) {
      // Error occurred and was handled by safeExecute
      final lastException = _exceptionHandler.exceptions.take(1);
      await for (final exception in lastException) {
        final userMessage = _errorMapper.mapExceptionToMessage(exception);
        emit(
            state.copyWith(status: ConnectionStatus.error, error: userMessage));
        break;
      }
    }
  }

  FutureOr<void> _onDisconnect(event, emit) async {
    await _exceptionHandler.safeExecute(() async {
      await _errSub?.cancel();
      // Keep the connection status subscription alive so future connects update status correctly
      await disconnectCtrlWsUseCase();
    });
    emit(state.copyWith(status: ConnectionStatus.disconnected));
  }

  void _onCheckConnection(event, emit) async {
    _exceptionHandler.safeExecuteSync(() {
      final isConnected = checkCtrlWsConnectedUseCase();
      final status = isConnected
          ? ConnectionStatus.ctrlWsConnected
          : ConnectionStatus.disconnected;
      emit(state.copyWith(status: status));
    });
  }

  FutureOr<void> _onConnectionChanged(event, emit) {
    emit(state.copyWith(status: event.connectionStatus, error: ''));
  }

  FutureOr<void> _onConnectionError(event, emit) {
    emit(state.copyWith(
        status: ConnectionStatus.error, error: event.errorMessage));
  }


  @override
  Future<void> close() async {
    await _errSub?.cancel();
    await _connectionStatusSub?.cancel();
    super.close();
  }
}
