import 'package:flutter_bloc/flutter_bloc.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class MowerConnectionBloc extends Bloc<MowerConnectionEvent, MowerConnectionState> {
  MowerConnectionBloc() : super(const MowerConnectionState()) {
    on<ConnectToMower>((event, emit) async {
      emit(state.copyWith(
        status: ConnectionStatus.connecting,
        ip: event.ipAddress,
        port: event.port,
      ));
      await Future.delayed(const Duration(seconds: 2)); // Simulate connection delay
      emit(state.copyWith(status: ConnectionStatus.connected));
    });
    on<DisconnectFromMower>((event, emit) {
      emit(state.copyWith(status: ConnectionStatus.disconnected));
    });
    on<CheckConnectionStatus>((event, emit) {
      // Here you would normally check the actual connection status
      if (state.status == ConnectionStatus.connected) {
        emit(state.copyWith(status: ConnectionStatus.connected));
      } else {
        emit(state.copyWith(status: ConnectionStatus.disconnected));
      }
    });
  }
}