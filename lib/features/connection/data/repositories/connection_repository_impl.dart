import 'dart:async';

import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
  String? _ipAddress;
  int? _port;

  final _controller = StreamController<bool>.broadcast();

  @override
  Future<void> connect(String ipAddress, int port) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate connection delay

    _ipAddress = ipAddress; // Store the IP address
    _port = port; // Store the port
    _controller.add(true); // Notify listeners about the connection status
  }

  @override
  Future<void> disconnect() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate disconnection delay

    _ipAddress = null; // Clear the stored IP address
    _port = null; // Clear the stored port
    _controller.add(false); // Notify listeners about the disconnection status
  }

  @override
  Future<bool> checkConnectionStatus() async {
    return _ipAddress != null ; // Return the current connection status
  }

  @override
  Stream<bool> connectionChanges() {
    return _controller.stream; // Return the stream of connection status changes
  }

  String? get ipAddress => _ipAddress; // Getter for IP address
  int? get port => _port; // Getter for port

  @override
  Future<String?> getTelemetryUrl() async {
    return (_ipAddress != null && _port != null)
        ? 'ws://$_ipAddress:$_port'
        : null; // Construct telemetry URL if IP and port are available
  }

  @override
  Stream<bool> get connectionStatusStream => _controller.stream; // Expose the connection status stream
}