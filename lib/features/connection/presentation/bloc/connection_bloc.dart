import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/data/repositories/connection_repository_impl.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_mower_status.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_mower.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_mower.dart';
import 'package:mower_bot/features/connection/domain/usecases/get_telemetry_url_usecase.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class MowerConnectionBloc
    extends Bloc<MowerConnectionEvent, MowerConnectionState> {
  final ConnectToMowerUseCase connectToMowerUseCase;
  final DisconnectMowerUseCase disconnectFromMowerUseCase;
  final CheckMowerStatusUseCase checkConnectionStatusUseCase;
  final GetTelemetryUrlUseCase getTelemetryUrlUseCase;
  final Stream<bool> connectionStream;
  final TelemetryBloc telemetryBloc;

  MowerConnectionBloc(
    this.connectToMowerUseCase,
    this.disconnectFromMowerUseCase,
    this.checkConnectionStatusUseCase,
    this.getTelemetryUrlUseCase,
    this.connectionStream,
      {
    required this.telemetryBloc,
  }) : super(const MowerConnectionState()) {
    on<ConnectToMower>(_onConnect);
    on<DisconnectFromMower>(_onDisconnect);
    on<CheckConnectionStatus>(_onCheckConnection);
    on<ConnectionChanged>(_onConnectionChanged);

    connectionStream.listen((isConnected) {
      add(ConnectionChanged(isConnected));
    });
  }

  FutureOr<void> _onConnectionChanged(event, emit) {
    emit(
      state.copyWith(
        status: event.isConnected
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
      ),
    );
  }

  FutureOr<void> _onCheckConnection(event, emit) async {
    final connected = await checkConnectionStatusUseCase();
    emit(
      state.copyWith(
        status: connected
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
      ),
    );
  }

  FutureOr<void> _onDisconnect(event, emit) async =>
    await disconnectFromMowerUseCase();

  FutureOr<void> _onConnect(event, emit) async {
    emit(
      state.copyWith(
        status: ConnectionStatus.connecting,
        ip: event.ipAddress,
        port: event.port,
      ),
    );

    await connectToMowerUseCase(event.ipAddress, event.port);

    final repo = connectToMowerUseCase.repository as MowerConnectionRepositoryImpl;
    if (repo.ipAddress != null || repo.port != null) {
      final wsURL = await getTelemetryUrlUseCase.call();
      if (wsURL != null) {
        telemetryBloc.add(StartTelemetry(wsUrl: wsURL));
      } else {
        emit(state.copyWith(status: ConnectionStatus.error));
        return;
      }
    }
  }
}
