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

class AutoDetectWifiMode extends MowerConnectionEvent {
  final String ssidPrefix;
  final Duration timeout;

  const AutoDetectWifiMode({
    this.ssidPrefix = 'Mower',
    this.timeout = const Duration(seconds: 30),
  });

  @override
  List<Object?> get props => [ssidPrefix, timeout];
}

class RetryAutoDetectWifiMode extends MowerConnectionEvent {
  const RetryAutoDetectWifiMode();
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

/// Internal-only events (used by [MowerConnectionBloc]) to safely bridge async
/// callbacks (Timer/Stream) back into the Bloc event loop.
///
/// Keep these in this file so they can be registered via `on<T>()`.
class WifiScanDetectedAp extends MowerConnectionEvent {
  const WifiScanDetectedAp();
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
