import 'dart:async';

import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';

class MowerConnectionRepositoryImpl implements MowerConnectionRepository {
  bool _isConnected = false;
  final _controller = StreamController<bool>.broadcast();

  @override
  Future<void> connect(String ipAddress, int port) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate connection delay
    _isConnected = true; // Simulate successful connection
    _controller.add(_isConnected); // Notify listeners about the connection status
  }

  @override
  Future<void> disconnect() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate disconnection delay
    _isConnected = false; // Simulate successful disconnection
    _controller.add(_isConnected); // Notify listeners about the disconnection status
  }

  @override
  Future<bool> checkConnectionStatus() async {
    return _isConnected; // Return the current connection status
  }

  @override
  Stream<bool> connectionChanges() {
    return _controller.stream; // Return the stream of connection status changes
  }
}