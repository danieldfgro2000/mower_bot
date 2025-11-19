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
  final ConnectionStatus connectionStatus;
  final String? ip;
  final int? port;
  final String? error;

  const MowerConnectionState({
    this.connectionStatus = ConnectionStatus.disconnected,
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
      connectionStatus: status ?? this.connectionStatus,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [connectionStatus, ip, port, error];

  @override
  Map<String, dynamic> toDiffMap() => {
    'status': connectionStatus,
    'ip': ip,
    'port': port,
    'error': error,
  };
}