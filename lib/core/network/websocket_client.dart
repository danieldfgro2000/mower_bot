import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/websocket_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef MessageHandler = void Function(Map<String, dynamic> message);

abstract class IWebSocketClient {
  Future<void> connect(Uri uri);

  Future<void> disconnect();

  void send(Map<String, dynamic> message);

  Stream<Map<String, dynamic>> get messages;

  bool get isConnected;
}

class WebSocketClient implements IWebSocketClient {
  final WebSocketConfig _webSocketConfig;
  WebSocketChannel? _channel;
  late final StreamController<Map<String, dynamic>> _controller;
  bool _isConnected = false;

  Timer? _pingTimer;
  Uri? _lastUri;
  int _reconnectAttempts = 0;
  bool _manuallyClosed = false;

  WebSocketClient(this._webSocketConfig) {
    _controller = StreamController<Map<String, dynamic>>.broadcast();
  }

  @override
  Stream<Map<String, dynamic>> get messages => _controller.stream;

  Future<bool> _tcpProbe(String host, int port, {Duration? timeout}) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: timeout ?? _webSocketConfig.reconnectMinDelay,
      );
      socket.destroy;
      return true;
    } catch (e) {
      if (kDebugMode) print("TCP probe failed for $host:$port - $e");
      return false;
    }
  }

  Future<void> _open(Uri uri) async {
    try {
      // 1) Preflight reachability check
      final host = uri.host;
      final port = uri.port;
      final isReachable = await _tcpProbe(host, port);

      if (!isReachable) {
        if (kDebugMode)
          print("Cannot reach $host:$port. Aborting WebSocket connection.");
        _controller.addError("Cannot reach $host:$port");
        _isConnected = false;
        _stopPing();
        _maybeReconnect();
        return;
      }

      // 2) Try to open the WebSocket connection (catch async throws)
      if (kDebugMode) print("WS: connecting to $uri");
      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;
      _reconnectAttempts = 0;

      _startPing();

      _channel!.stream.listen(
        (data) {
          try {
            final message = jsonDecode(data);
            if (message is Map<String, dynamic>) {
              _controller.add(message);
            }
          } catch (e) {
            if (kDebugMode) {
              print("Error decoding message: $e");
            }
          }
        },
        onError: (error) {
          _isConnected = false;
          _stopPing();
          _controller.addError(error);
          _maybeReconnect();
        },
        onDone: () {
          _isConnected = false;
          _stopPing();
          if (!_manuallyClosed) {
            _maybeReconnect();
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      _isConnected = false;
      _stopPing();
      _controller.addError(e);
      _maybeReconnect();
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    if (_webSocketConfig.pingInterval.inMilliseconds <= 0) return;
    _pingTimer = Timer.periodic(_webSocketConfig.pingInterval, (_) {
      if (_isConnected && _channel != null) {
        send(const {'type': 'ping'});
      }
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _maybeReconnect() {
    if (_manuallyClosed || _lastUri == null) return;
    if (_reconnectAttempts >= _webSocketConfig.maxReconnectAttempts) {
      if (kDebugMode) print("Max reconnect attempts reached. Not reconnecting.");
      _controller.addError(
        "Max reconnect attempts reached: ${_webSocketConfig.maxReconnectAttempts}",
      );
    }

    final delay = _nextBackoff(
      _webSocketConfig.reconnectMinDelay,
      _webSocketConfig.reconnectMaxDelay,
      _reconnectAttempts,
    );
    _reconnectAttempts++;

    if (kDebugMode) {
      print("WS: Reconnecting in ${delay.inSeconds} seconds...");
    }
    Future.delayed(delay, () async {
      if (kDebugMode) {
        print("WS: Attempting to reconnect to $_lastUri");
      }
      try {
        if (!_manuallyClosed && !_isConnected) {
          await _open(_lastUri!);
        }
      } catch (e) {
        if (kDebugMode) {
          print("WS: Reconnect failed: $e");
        }
      }
    });
  }

  Duration _nextBackoff(Duration minDelay, Duration maxDelay, int attempt) {
    final baseMs = minDelay.inMilliseconds * (1 << attempt);
    final capped = baseMs > maxDelay.inMilliseconds
        ? maxDelay.inMilliseconds
        : baseMs;
    final jitter = (capped * 0.2).toInt();
    final actual =
        capped +
        (jitter == 0
            ? 0
            : (DateTime.now().microsecond % (2 * jitter)) - jitter);
    return Duration(
      milliseconds: actual.clamp(
        minDelay.inMilliseconds,
        maxDelay.inMilliseconds,
      ),
    );
  }

  @override
  Future<void> connect(Uri uri) async {
    _manuallyClosed = false;
    _lastUri = uri;
    await _open(uri);
  }

  @override
  void send(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  @override
  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close(status.normalClosure);
      _isConnected = false;
    }
  }

  @override
  bool get isConnected => _isConnected;
}
