import 'package:equatable/equatable.dart';
import '../../../../core/diffable_state.dart';

enum ConnectionStatus{
  disconnected,
  connecting,
  ctrlWsConnected,
  videoWsConnected,
  hostUnreachable,
  error
}

class MowerConnectionState extends Equatable implements DiffableState {
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

  @override
  Map<String, dynamic> toDiffMap() => {
    'status': status,
    'ip': ip,
    'port': port,
    'error': error,
  };
}