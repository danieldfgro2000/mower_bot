import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_mower_status.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_mower.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_mower.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class MowerConnectionBloc
    extends Bloc<MowerConnectionEvent, MowerConnectionState> {
  final ConnectToMowerUseCase connectToMowerUseCase;
  final DisconnectMowerUseCase disconnectFromMowerUseCase;
  final CheckMowerStatusUseCase checkConnectionStatusUseCase;
  final TelemetryBloc telemetryBloc;
  final MowerConnectionRepository repo;
  StreamSubscription? _errSub;

  MowerConnectionBloc(
    this.connectToMowerUseCase,
    this.disconnectFromMowerUseCase,
    this.checkConnectionStatusUseCase,
    this.telemetryBloc,
    this.repo
  ) : super(const MowerConnectionState()) {
    on<ConnectToMower>(_onConnect);
    on<DisconnectFromMower>(_onDisconnect);
    on<CheckConnectionStatus>(_onCheckConnection);
    on<ConnectionError>(_onConnectionError);
  }

  FutureOr<void> _onConnect(event, emit) async {
    emit(
      state.copyWith(
        status: ConnectionStatus.connecting,
        ip: event.ipAddress,
        port: event.port,
      ),
    );

    try {
      await connectToMowerUseCase(event.ipAddress, event.port);
      await _errSub?.cancel();
      _errSub = repo.errors().listen((e) => add(ConnectionError(e.toString())));
      emit(state.copyWith(status: ConnectionStatus.connected));
      telemetryBloc.add(StartTelemetry());
    } catch (e) {
      emit(
        state.copyWith(
          status: ConnectionStatus.error,
          error: e.toString()
        ),
      );
      return;
    }
  }

  FutureOr<void> _onDisconnect(event, emit) async {
    await _errSub?.cancel();
    await disconnectFromMowerUseCase();
    emit(state.copyWith(
      status: ConnectionStatus.disconnected,
    ));
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

  void _onConnectionError(event, emit) async {
    emit(
      state.copyWith(
        error: event.error
      )
    );
  }
}
