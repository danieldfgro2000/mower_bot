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

class ChangeWiFiMode extends MowerConnectionEvent {
  final ESP32WiFiMode mode;

  const ChangeWiFiMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ChangeApSsid extends MowerConnectionEvent {
  final String ssid;

  const ChangeApSsid(this.ssid);

  @override
  List<Object?> get props => [ssid];
}

class ChangeApPassword extends MowerConnectionEvent {
  final String password;

  const ChangeApPassword(this.password);

  @override
  List<Object?> get props => [password];
}

class AutoDetectWifiMode extends MowerConnectionEvent {
  final String ssidPrefix;
  final Duration timeout;

  const AutoDetectWifiMode({
    this.ssidPrefix = 'Mower',
    this.timeout = const Duration(seconds: 5),
  });

  @override
  List<Object?> get props => [ssidPrefix, timeout];
}

class RetryAutoDetectWifiMode extends MowerConnectionEvent {
  const RetryAutoDetectWifiMode();
}

class ConnectToControlWebsocketMower extends MowerConnectionEvent {}

/// Automatically join mower Wi‑Fi (best effort), wait for network handshake, then connect WS.
class AutoConnectToMower extends MowerConnectionEvent {
  const AutoConnectToMower();
}

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

/// Internal-only events (used by [MowerConnectionBloc]) to safely bridge async
/// callbacks (Timer/Stream) back into the Bloc event loop.
///
/// Keep these in this file so they can be registered via `on<T>()`.
class WifiScanDetectedAp extends MowerConnectionEvent {
  final String? ssid;

  const WifiScanDetectedAp({this.ssid});

  @override
  List<Object?> get props => [ssid];
}

/// Internal event carrying the SSID we discovered.
///
/// This avoids calling `emit(...)` from inside a Stream/Timer callback.
class WifiScanFoundSsid extends MowerConnectionEvent {
  final String ssid;

  const WifiScanFoundSsid(this.ssid);

  @override
  List<Object?> get props => [ssid];
}

class WifiScanTimedOut extends MowerConnectionEvent {
  const WifiScanTimedOut();
}

class WifiScanFailed extends MowerConnectionEvent {
  final String message;

  const WifiScanFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class WifiScanPermissionInfoAccepted extends MowerConnectionEvent {
  const WifiScanPermissionInfoAccepted();
}

class WifiScanPermissionInfoDeclined extends MowerConnectionEvent {
  const WifiScanPermissionInfoDeclined();
}

// Internal auto-connect steps
class AutoJoinWifiResult extends MowerConnectionEvent {
  final bool connected;
  final String? ssid;

  const AutoJoinWifiResult({required this.connected, this.ssid});

  @override
  List<Object?> get props => [connected, ssid];
}

class ReachabilityResult extends MowerConnectionEvent {
  final bool reachable;

  const ReachabilityResult(this.reachable);

  @override
  List<Object?> get props => [reachable];
}
