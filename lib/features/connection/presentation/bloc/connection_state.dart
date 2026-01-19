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

enum ESP32WiFiMode { client, ap }

enum WifiScanStatus { idle, scanning, completed, timeout, failed }

class MowerConnectionState extends Equatable implements DiffableState {
  final ConnectionStatus connectionStatus;
  final ESP32WiFiMode wifiMode;
  final WifiScanStatus wifiScanStatus;
  final String? ip;
  final int? port;
  final String? error;

  const MowerConnectionState({
    this.connectionStatus = ConnectionStatus.disconnected,
    this.wifiMode = ESP32WiFiMode.client,
    this.wifiScanStatus = WifiScanStatus.idle,
    this.ip,
    this.port,
    this.error
  });

  MowerConnectionState copyWith({
    ConnectionStatus? status,
    ESP32WiFiMode? wifiMode,
    WifiScanStatus? wifiScanStatus,
    String? ip,
    int? port,
    String? error,
  }) {
    return MowerConnectionState(
      connectionStatus: status ?? this.connectionStatus,
      wifiMode: wifiMode ?? this.wifiMode,
      wifiScanStatus: wifiScanStatus ?? this.wifiScanStatus,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [connectionStatus, wifiMode, wifiScanStatus, ip, port, error];

  @override
  Map<String, dynamic> toDiffMap() => {
    'status': connectionStatus,
    'wifiMode': wifiMode,
    'wifiScanStatus': wifiScanStatus,
    'ip': ip,
    'port': port,
    'error': error,
  };
}