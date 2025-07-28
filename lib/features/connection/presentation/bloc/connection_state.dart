import 'package:equatable/equatable.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error
}

class MowerConnectionState extends Equatable {
  final ConnectionStatus status;
  final String? ip;
  final int? port;

  const MowerConnectionState({
    this.status = ConnectionStatus.disconnected,
    this.ip,
    this.port,
  });

  MowerConnectionState copyWith({
    ConnectionStatus? status,
    String? ip,
    int? port,
  }) {
    return MowerConnectionState(
      status: status ?? this.status,
      ip: ip ?? this.ip,
      port: port ?? this.port,
    );
  }

  @override
  List<Object?> get props => [status, ip, port];
}