import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/data/network/websocket_config.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';
import 'package:web_socket_channel/io.dart';

typedef JsonMap = Map<String, dynamic>;
typedef JsonHandler = void Function(JsonMap message);
typedef BinaryHandler = void Function(Uint8List data);
typedef ErrorHandler = void Function(String error, [StackTrace? stackTrace]);
typedef ConnectionChanged = void Function(ConnectionStatus connStatus);

enum WsPayloadMode { jsonOnly, binaryOnly, jsonAndBinary }

class WebSocketAdapter {
  WebSocketAdapter({WebSocketConfig? config}) : wscfg = config ?? WebSocketConfig();

  final WebSocketConfig wscfg;

  IOWebSocketChannel? _webSocketChannel;

  Uri? _lastUri;
  bool _isOpen = false;
  bool _manuallyClosed = false;

  int _reconnectAttempts = 0;
  
  final _jsonCtrl = StreamController<JsonMap>.broadcast();
  final _binaryCtrl = StreamController<Uint8List>.broadcast();
  Stream<JsonMap> get json => _jsonCtrl.stream;
  Stream<Uint8List> get binary => _binaryCtrl.stream;

  bool get isOpen => _isOpen && _webSocketChannel != null;

  Future<void> openWebsocketChannel({
    Uri? uri,
    WsPayloadMode mode = WsPayloadMode.jsonAndBinary,
    required ErrorHandler onError,
    required ConnectionChanged onConnectionChanged,
    required VoidCallback onReconnect,
  }) async {
    _manuallyClosed = false;

    _lastUri = uri ?? _lastUri;
    uri ??= _lastUri;
    final host = uri?.host;
    final port = uri?.port;

    if (host == null || port == null) {
      _notifyClosed();
      onConnectionChanged(ConnectionStatus.disconnected);
      onError("WebSocketAdapter: endpoint is not set");
      throw StateError("WebSocketAdapter: endpoint is not set");
    }

    final isReachable = await _tcpProbe(host, port);

    if (!isReachable) {
      final err = "Cannot reach $host:$port. Aborting WebSocket connection.";
      if (kDebugMode) print(err);
      _notifyClosed();
      onConnectionChanged(ConnectionStatus.hostUnreachable);
      onError(err);
      return;
    }

    try {
      if (kDebugMode) print("WS: connecting to $uri");
      onConnectionChanged(ConnectionStatus.connecting);
      final socket = await WebSocket.connect(uri.toString());
      socket.pingInterval = wscfg.ping3sec;

      _webSocketChannel = IOWebSocketChannel(socket);
      if (_webSocketChannel != null) {
        _isOpen = true;
        _reconnectAttempts = 0;
        onConnectionChanged(ConnectionStatus.ctrlWsConnected);
      }

      _webSocketChannel?.stream.listen(
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
                final bytes = Uint8List.fromList(data);
                final out = handleBinary(bytes);
                if (out != null) _binaryCtrl.add(out);
                break;
              default:
                if (kDebugMode) {
                  print("[WS] Unsupported data type: ${data.runtimeType}");
                }
                break;
            }
          } catch (e, st) {
            if (kDebugMode) print("Error decoding message: $e, stacktrace: $st");
            onError("Error decoding message: $e", st);
          }
        },
        onError: (error) {
          if (kDebugMode) print("[WS] onError: $error");
          _onStreamClosed(onReconnect, onConnectionChanged, onError);
        },
        onDone: () {
          if (kDebugMode) print("[WS] onDone:: connection closed by remote");
          _onStreamClosed(onReconnect, onConnectionChanged, onError);
        },
        cancelOnError: false,
      );
    } catch (e, st) {
      onError("Message decode error: $e", st);
      _notifyClosed();
      onConnectionChanged(ConnectionStatus.error);
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
    _manuallyClosed = manuallyClosed;
    _webSocketChannel?.sink.close(WebSocketStatus.normalClosure);
    _webSocketChannel = null;
    _isOpen = false;
  }

  Future<bool> _tcpProbe(String host, int port) async {
    try {
      final socket = await Socket.connect(host, port, timeout:  wscfg.timeout3sec);
      socket.destroy();
      return true;
    } catch (e) {
      if (kDebugMode) print("TCP probe failed for $host:$port - $e");
      return false;
    }
  }

  void _onStreamClosed(
    VoidCallback onReconnect,
    ConnectionChanged? onConnectionChanged,
    ErrorHandler? onError,
  ) {
    _notifyClosed();
    onConnectionChanged?.call(ConnectionStatus.disconnected);

    if (_manuallyClosed) {
      if (kDebugMode) print("[WS] manually closed: $_manuallyClosed)");
      return;
    }

    if (_reconnectAttempts >= wscfg.max5attempts) {
      if (kDebugMode) print("[WS]: Max attempts reached. Not reconnecting.");
      onError?.call("Max reconnect attempts reached: ${wscfg.max5attempts}");
      return;
    }

    final delay = _nextBackoff(
      wscfg.retry100millis,
      wscfg.retry300millis,
      _reconnectAttempts,
    );
    _reconnectAttempts++;

    if (kDebugMode) {
      print(
        "WS: Reconnecting in ${delay.inMilliseconds} millis... "
            "(attempt $_reconnectAttempts/${wscfg.max5attempts})"
      );
    }

    Future.delayed(delay, onReconnect);
  }

  void _notifyClosed() {
    _isOpen = false;
    _webSocketChannel = null;
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

    if (stats.lastArrivalMs != null) {
      debugPrint('[VIDEO] Arrival Dt: ${now - stats.lastArrivalMs!} ms');
    }
    stats.lastArrivalMs = now;
    return msg;
  } catch (e, st) {
    debugPrint('[VIDEO] Error handling binary message: $e, stacktrace: $st');
    return null;
  }
}
