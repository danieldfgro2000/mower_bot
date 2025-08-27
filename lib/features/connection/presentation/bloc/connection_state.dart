import 'package:equatable/equatable.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  ctrlWsConnected,
  videoWsConnected,
  error
}

class MowerConnectionState extends Equatable {
  final ConnectionStatus status;
  final String? ip;
  final int? port;
  final String? error;

  const MowerConnectionState({
    this.status = ConnectionStatus.disconnected,
    this.ip,
    this.port,
    this.error
  });

  MowerConnectionState copyWith({
    ConnectionStatus? status,
    String? ip,
    int? port,
    String? error,
  }) {
    return MowerConnectionState(
      status: status ?? this.status,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, ip, port, error];
}