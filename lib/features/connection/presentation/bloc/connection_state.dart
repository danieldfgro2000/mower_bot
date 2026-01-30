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

enum WifiScanStatus { idle, scanning, needsPermission, completed, timeout, failed }

class MowerConnectionState extends Equatable implements DiffableState {
  final ConnectionStatus connectionStatus;
  final ESP32WiFiMode wifiMode;
  final WifiScanStatus wifiScanStatus;
  final String? ip;
  final int? port;
  final String? error;
  final String? detectedApSsid;

  /// Default mower AP credentials (used for auto-join on Android and to prefill UI).
  final String apSsid;
  final String apPassword;

  const MowerConnectionState({
    this.connectionStatus = ConnectionStatus.disconnected,
    this.wifiMode = ESP32WiFiMode.client,
    this.wifiScanStatus = WifiScanStatus.idle,
    this.ip,
    this.port,
    this.error,
    this.detectedApSsid,
    this.apSsid = 'MowerBot-AP',
    this.apPassword = 'mowerbot123',
  });

  MowerConnectionState copyWith({
    ConnectionStatus? status,
    ESP32WiFiMode? wifiMode,
    WifiScanStatus? wifiScanStatus,
    String? ip,
    int? port,
    String? error,
    String? detectedApSsid,
    String? apSsid,
    String? apPassword,
  }) {
    return MowerConnectionState(
      connectionStatus: status ?? this.connectionStatus,
      wifiMode: wifiMode ?? this.wifiMode,
      wifiScanStatus: wifiScanStatus ?? this.wifiScanStatus,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      error: error ?? this.error,
      detectedApSsid: detectedApSsid ?? this.detectedApSsid,
      apSsid: apSsid ?? this.apSsid,
      apPassword: apPassword ?? this.apPassword,
    );
  }

  @override
  List<Object?> get props => [
        connectionStatus,
        wifiMode,
        wifiScanStatus,
        ip,
        port,
        error,
        detectedApSsid,
        apSsid,
        apPassword,
      ];

  @override
  Map<String, dynamic> toDiffMap() => {
        'status': connectionStatus,
        'wifiMode': wifiMode,
        'wifiScanStatus': wifiScanStatus,
        'ip': ip,
        'port': port,
        'error': error,
        'detectedApSsid': detectedApSsid,
        'apSsid': apSsid,
        'apPassword': apPassword,
      };
}