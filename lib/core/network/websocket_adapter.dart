import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/websocket_config.dart';
import 'package:web_socket_channel/io.dart';

typedef JsonMap = Map<String, dynamic>;
typedef JsonHandler = void Function(JsonMap message);
typedef BinaryHandler = void Function(Uint8List data);
typedef ErrorHandler = void Function(String error, [StackTrace? stackTrace]);
typedef ConnectionChanged = void Function(bool isOpen);

enum WsPayloadMode { jsonOnly, binaryOnly, jsonAndBinary }

class WebSocketAdapter {
  WebSocketAdapter({WebSocketConfig? config})
    : cfg = config ?? WebSocketConfig();

  final WebSocketConfig cfg;

  IOWebSocketChannel? _webSocketChannel;
  StreamSubscription? _sub;

  Uri? _lastUri;
  bool _isOpen = false;
  bool _manuallyClosed = false;
  int _reconnectAttempts = 0;

  final _jsonCtrl = StreamController<JsonMap>.broadcast();
  final _binaryCtrl = StreamController<Uint8List>.broadcast();

  Stream<JsonMap> get json => _jsonCtrl.stream;

  Stream<Uint8List> get binary => _binaryCtrl.stream;

  bool get isOpen => _isOpen && _webSocketChannel != null;

  Uri? get endpoint => _lastUri;

  IOWebSocketChannel? get webSocketChannel => _webSocketChannel;

  Future<void> openWebsocketChannel({
    Uri? uri,
    WsPayloadMode mode = WsPayloadMode.jsonAndBinary,
    ErrorHandler? onError,
    ConnectionChanged? onConnectionChanged,
  }) async {
    _manuallyClosed = false;

    _lastUri = uri ?? _lastUri;
    uri ??= _lastUri;
    final host = uri?.host;
    final port = uri?.hasPort == true
        ? uri?.port
        : (uri!.scheme == 'wss' ? 443 : 80);

    if (host == null || port == null) {
      _notifyClosed(onConnectionChanged);
      onError?.call("WebSocketAdapter: endpoint is not set");
      throw StateError("WebSocketAdapter: endpoint is not set");
    }

    final isReachable = await tcpProbe(
      host,
      port,
      timeout: cfg.connectProbeTimeout,
    );

    if (!isReachable) {
      final err = "Cannot reach $host:$port. Aborting WebSocket connection.";
      if (kDebugMode) print(err);
      onError?.call(err);
      _notifyClosed(onConnectionChanged);
      throw err;
    }

    try {
      if (kDebugMode) print("WS: connecting to $uri");
      final socket = await WebSocket.connect(uri.toString());
      socket.pingInterval = cfg.pingInterval;

      _webSocketChannel = IOWebSocketChannel(socket);
      _isOpen = true;
      _reconnectAttempts = 0;
      onConnectionChanged?.call(true);

      _sub = webSocketChannel!.stream.listen(
        (data) {
          try {
            switch (data) {
              case String():
                if (mode == WsPayloadMode.binaryOnly) return;
                final message = jsonDecode(data);
                if (message is JsonMap) _jsonCtrl.add(message);
                break;
              case List<int>():
                if (mode == WsPayloadMode.jsonOnly) return;
                final out = handleBinary(Uint8List.fromList(data));
                if (out != null) _binaryCtrl.add(out);
                break;
              default:
                if (kDebugMode) {
                  print("Received unsupported data type: ${data.runtimeType}");
                }
                break;
            }
          } catch (e, st) {
            if (kDebugMode) {
              print("Error decoding message: $e");
            }
          }
        },
        onError: (error) {
          if (kDebugMode) print("WS: onError: $error");
          _onStreamClosed(onConnectionChanged, onError);
        },
        onDone: () {
          if (kDebugMode) {
            print("WS: onDone:: connection closed by remote or locally");
          }
          _onStreamClosed(onConnectionChanged, onError);
        },
        cancelOnError: false,
      );
    } catch (e, st) {
      onError?.call(e.toString(), st);
      _notifyClosed(onConnectionChanged);
      rethrow;
    }
  }

  void sendText(String text) {
    final ch = _webSocketChannel;
    if (ch == null) return;
    ch.sink.add(text);
  }

  void sendBytes(Uint8List data) {
    final ch = _webSocketChannel;
    if (ch == null) return;
    ch.sink.add(data);
  }

  Future<void> close({bool manuallyClosed = false}) async {
    _manuallyClosed = manuallyClosed || manuallyClosed;
    _webSocketChannel?.sink.close(WebSocketStatus.normalClosure);
    await _sub?.cancel();
    _webSocketChannel = null;
    _isOpen = false;
  }

  Future<bool> tcpProbe(String host, int port, {Duration? timeout}) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: timeout ?? cfg.reconnectMinDelay,
      );
      socket.destroy();
      return true;
    } catch (e) {
      if (kDebugMode) print("TCP probe failed for $host:$port - $e");
      return false;
    }
  }

  void _onStreamClosed(
    ConnectionChanged? onConnectionChanged,
    ErrorHandler? onError,
  ) {
    _notifyClosed(onConnectionChanged);
    if (_manuallyClosed || !cfg.autoReconnect) {
      if (kDebugMode) {
        print(
          "WS: Not reconnecting ("
          "manually closed: $_manuallyClosed,  "
          "autoReconnect: ${cfg.autoReconnect})",
        );
      }
      return;
    }

    if (_reconnectAttempts >= cfg.maxReconnectAttempts) {
      if (kDebugMode) {
        print("WS: Max reconnect attempts reached. Not reconnecting.");
      }
      onError?.call(
        "Max reconnect attempts reached: ${cfg.maxReconnectAttempts}",
      );
      return;
    }

    final delay = _nextBackoff(
      cfg.reconnectMinDelay,
      cfg.reconnectMaxDelay,
      _reconnectAttempts,
    );
    _reconnectAttempts++;
    if (kDebugMode) {
      print(
        "WS: Reconnecting in ${delay.inSeconds} seconds... (attempt $_reconnectAttempts/${cfg.maxReconnectAttempts})",
      );
    }
    maybeReconnect(
      onReconnect: () => openWebsocketChannel(),
      onError: () => onError?.call("Reconnection failed"),
    );
  }

  void _notifyClosed(ConnectionChanged? onConnectionChanged) {
    _isOpen = false;
    onConnectionChanged?.call(false);
    _sub?.cancel();
    _sub = null;
    _webSocketChannel = null;
  }

  void maybeReconnect({
    required VoidCallback onReconnect,
    required VoidCallback onError,
  }) {
    if (_reconnectAttempts >= cfg.maxReconnectAttempts) {
      if (kDebugMode) {
        print("Max reconnect attempts reached. Not reconnecting.");
      }
      onError();
      return;
    }

    final delay = _nextBackoff(
      cfg.reconnectMinDelay,
      cfg.reconnectMaxDelay,
      _reconnectAttempts,
    );
    _reconnectAttempts++;

    if (kDebugMode) print("WS: Reconnecting in ${delay.inSeconds} seconds...");

    Future.delayed(delay, () async {
      if (kDebugMode) print("WS: Attempting to reconnect");
      onReconnect();
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

  Future<void> dispose() async {
    await close(manuallyClosed: true);
    await _jsonCtrl.close();
    await _binaryCtrl.close();
  }
}

class RxStats {
  int rxThisSec = 0, rxFps = 0;
  int lastSecMs = 0;
  int? lastArrivalMs;
  int? lastSeq;
}

final stats = RxStats();

Uint8List? handleBinary(Uint8List msg) {
  try {
    final now = DateTime.now().millisecondsSinceEpoch;

    stats.rxThisSec++;
    stats.lastSecMs = (stats.lastSecMs == 0) ? now : stats.lastSecMs;
    if (now - stats.lastSecMs >= 1000) {
      stats.rxFps = stats.rxThisSec;
      stats.rxThisSec = 0;
      stats.lastSecMs = now;
      debugPrint('[VIDEO] RX FPS: ${stats.rxFps}');
    }

    // interval arrival Dt
    if (stats.lastArrivalMs != null) {
      debugPrint('[VIDEO] Arrival Dt: ${now - stats.lastArrivalMs!} ms');
    }
    stats.lastArrivalMs = now;

  } catch (e, st) {
    debugPrint('[VIDEO] Error handling binary message: $e, stacktrace: $st');
    return null;
  }
  return null;
}
