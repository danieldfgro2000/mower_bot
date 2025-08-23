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
  Stream<Uint8List> get binary;

  bool get isConnected;
}

class WebSocketClient implements IWebSocketClient {
  final WebSocketConfig _webSocketConfig;
  WebSocketChannel? _channel;
  late final StreamController<Map<String, dynamic>> _jsonStringController;
  late final StreamController<Uint8List> _binaryController;

  Timer? _pingTimer;
  Uri? _lastUri;
  int _reconnectAttempts = 0;
  bool _manuallyClosed = false;

  WebSocketClient(this._webSocketConfig) {
    _jsonStringController = StreamController<Map<String, dynamic>>.broadcast();
    _binaryController = StreamController<Uint8List>.broadcast();
  }

  @override
  Stream<Map<String, dynamic>> get messages => _jsonStringController.stream;

  Future<bool> _tcpProbe(String host, int port, {Duration? timeout}) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: timeout ?? _webSocketConfig.reconnectMinDelay,
      );
      socket.destroy();
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
        final err = SocketException("Cannot reach $host:$port. Aborting WebSocket connection.");
        if (kDebugMode) print(err);
        _jsonStringController.addError("Cannot reach $host:$port");
        stopPing();
        throw err;
      }

      // 2) Try to open the WebSocket connection (catch async throws)
      if (kDebugMode) print("WS: connecting to $uri");
      _channel = WebSocketChannel.connect(uri);
      _reconnectAttempts = 0;

      startPing();

      _channel!.stream.listen(
        (data) {
          try {
            switch (data) {
              case String(): {
                final message = jsonDecode(data);
                if (message is Map<String, dynamic>) {
                  _jsonStringController.add(message);
                }
              }
              case List<int>(): {
                _binaryController.add(Uint8List.fromList(data));
              }
              default: {
                if (kDebugMode) {
                  print("Received unsupported data type: ${data.runtimeType}");
                }
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print("Error decoding message: $e");
            }
          }
        },
        onError: (error) {
          stopPing();
          _jsonStringController.addError(error);
        },
        onDone: () {
          stopPing();
          if (!_manuallyClosed) _maybeReconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      stopPing();
      _jsonStringController.addError(e);
      rethrow;
    }
  }

  void startPing() {
    _pingTimer?.cancel();
    if (_webSocketConfig.pingInterval.inMilliseconds <= 0) return;
    _pingTimer = Timer.periodic(_webSocketConfig.pingInterval, (_) {
      if (_channel != null) {
        send(const {'type': 'ping'});
      }
    });
  }

  void stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _maybeReconnect() {
    if (_manuallyClosed || _lastUri == null) return;
    if (_reconnectAttempts >= _webSocketConfig.maxReconnectAttempts) {
      if (kDebugMode) print("Max reconnect attempts reached. Not reconnecting.");
      _jsonStringController.addError(
        "Max reconnect attempts reached: ${_webSocketConfig.maxReconnectAttempts}",
      );
      return;
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
        if (!_manuallyClosed && _channel == null) {
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
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }
  
  @override
  Stream<Uint8List> get binary => _binaryController.stream;

  @override
  Future<void> disconnect() async {
    _manuallyClosed = true;
    stopPing();
    if (_channel != null) {
      await _channel!.sink.close(status.normalClosure);
    }
  }

  @override
  bool get isConnected => _channel != null;
}
