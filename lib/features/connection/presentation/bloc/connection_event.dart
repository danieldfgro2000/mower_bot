import 'package:equatable/equatable.dart';

import 'connection_state.dart';

abstract class MowerConnectionEvent extends Equatable {
  const MowerConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ChangeIp extends MowerConnectionEvent {
  final String ipAddress;

  const ChangeIp(this.ipAddress);

  @override
  List<Object?> get props => [ipAddress];
}

class ConnectToMower extends MowerConnectionEvent {}

class DisconnectFromMower extends MowerConnectionEvent {}

class CheckConnectionStatus extends MowerConnectionEvent {}

class ConnectionChanged extends MowerConnectionEvent {
  final ConnectionStatus connectionStatus;

  const ConnectionChanged({required this.connectionStatus});

  @override
  List<Object?> get props => [connectionStatus];
}

class ConnectionError extends MowerConnectionEvent {
  final String? error;

  const ConnectionError(this.error);

  @override
  List<Object?> get props => [error];
}