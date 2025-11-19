import 'package:equatable/equatable.dart';
import 'package:mower_bot/core/error/app_exception.dart';

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

class ChangePort extends MowerConnectionEvent {
  final int port;

  const ChangePort(this.port);

  @override
  List<Object?> get props => [port];
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
  final AppException exception;

  const ConnectionError(this.exception);

  @override
  List<Object?> get props => [exception];
}