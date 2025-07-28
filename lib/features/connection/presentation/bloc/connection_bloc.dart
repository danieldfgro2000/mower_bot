import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_mower_status.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_mower.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_mower.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class MowerConnectionBloc
    extends Bloc<MowerConnectionEvent, MowerConnectionState> {
  final ConnectToMowerUseCase connectToMowerUseCase;
  final DisconnectMowerUseCase disconnectFromMowerUseCase;
  final CheckMowerStatusUseCase checkConnectionStatusUseCase;
  final Stream<bool> connectionStream;

  MowerConnectionBloc(
    this.connectToMowerUseCase,
    this.disconnectFromMowerUseCase,
    this.checkConnectionStatusUseCase,
    this.connectionStream,
  ) : super(const MowerConnectionState()) {
    on<ConnectToMower>((event, emit) async {
      emit(
        state.copyWith(
          status: ConnectionStatus.connecting,
          ip: event.ipAddress,
          port: event.port,
        ),
      );
      await connectToMowerUseCase(event.ipAddress, event.port);
      // emit(state.copyWith(status: ConnectionStatus.connected));
    });
    on<DisconnectFromMower>((event, emit) async {
      await disconnectFromMowerUseCase();
      // emit(state.copyWith(status: ConnectionStatus.disconnected));
    });
    on<CheckConnectionStatus>((event, emit) async {
      final connected = await checkConnectionStatusUseCase();
      emit(
        state.copyWith(
          status: connected
              ? ConnectionStatus.connected
              : ConnectionStatus.disconnected,
        ),
      );
    });
    connectionStream.listen((isConnected) {
      add(ConnectionChanged(isConnected));
    });
    on<ConnectionChanged>((event, emit) {
      emit(
        state.copyWith(
          status: event.isConnected
              ? ConnectionStatus.connected
              : ConnectionStatus.disconnected,
        ),
      );
    });
  }
}
