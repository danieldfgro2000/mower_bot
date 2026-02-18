import 'dart:async';

import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

/// A lightweight fake IWebSocketClient for unit tests.
///
/// - Emits JSON messages via [emitMessage]
/// - Emits connection changes via [emitConnection]
/// - Tracks sent messages in [sent]
class FakeWebSocketClient implements IWebSocketClient {
  Uri? _endpoint;

  final List<JsonMap> sent = [];

  bool _isConnected = false;

  final StreamController<JsonMap> _messagesCtrl = StreamController<JsonMap>.broadcast();
  final StreamController<ConnectionStatus> _connectionCtrl =
      StreamController<ConnectionStatus>.broadcast();

  @override
  Uri? get endpoint => _endpoint;

  @override
  void setEndpoint(Uri uri) => _endpoint = uri;

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<JsonMap> get messages => _messagesCtrl.stream;

  @override
  Stream<ConnectionStatus> get connectionChanged => _connectionCtrl.stream;

  @override
  Future<void> connect({bool fromReconnect = false}) async {
    _isConnected = true;
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
  }

  @override
  void send(JsonMap message) {
    sent.add(message);
  }

  void emitMessage(JsonMap message) => _messagesCtrl.add(message);

  void emitMessageError(Object error, [StackTrace? st]) => _messagesCtrl.addError(error, st);

  void emitConnection(ConnectionStatus status) {
    if (status == ConnectionStatus.ctrlWsConnected || status == ConnectionStatus.videoWsConnected) {
      _isConnected = true;
    }
    if (status == ConnectionStatus.disconnected) {
      _isConnected = false;
    }
    _connectionCtrl.add(status);
  }

  @override
  void dispose() {
    _messagesCtrl.close();
    _connectionCtrl.close();
  }
}

