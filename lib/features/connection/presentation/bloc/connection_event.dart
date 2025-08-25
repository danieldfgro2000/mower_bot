import 'package:equatable/equatable.dart';

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
  final String port;

  const ChangePort(this.port);

  @override
  List<Object?> get props => [port];
}

class ConnectToMower extends MowerConnectionEvent {}

class DisconnectFromMower extends MowerConnectionEvent {}

class CheckConnectionStatus extends MowerConnectionEvent {}

class ConnectionChanged extends MowerConnectionEvent {
  final bool isConnected;

  const ConnectionChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class ConnectionError extends MowerConnectionEvent {
  final String? error;

  const ConnectionError(this.error);

  @override
  List<Object?> get props => [error];
}