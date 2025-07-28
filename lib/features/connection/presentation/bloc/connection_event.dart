import 'package:equatable/equatable.dart';

abstract class MowerConnectionEvent extends Equatable {
  const MowerConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectToMower extends MowerConnectionEvent {
  final String ipAddress;
  final int port;

  const ConnectToMower(this.ipAddress, this.port);

  @override
  List<Object?> get props => [ipAddress, port];
}

class DisconnectFromMower extends MowerConnectionEvent {}

class CheckConnectionStatus extends MowerConnectionEvent {}

class ConnectionChanged extends MowerConnectionEvent {
  final bool isConnected;

  const ConnectionChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}