import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/network/websocket_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

typedef JsonMap = Map<String, dynamic>;
typedef JsonHandler = void Function(JsonMap message);
typedef BinaryHandler = void Function(Uint8List data);
typedef ErrorHandler = void Function(String error, [StackTrace? stackTrace]);
typedef ConnectionChanged = void Function(bool isOpen);

class NetworkHelpers {
  late final WebSocketConfig cfg;

  IOWebSocketChannel? _webSocketChannel;
  StreamSubscription? _sub;
  bool _isOpen = false;
  bool _manuallyClosed = false;
  int _reconnectAttempts = 0;
  Uri? _lastUri;

  NetworkHelpers({WebSocketConfig? config}) : cfg = config ?? WebSocketConfig();

  IOWebSocketChannel? get webSocketChannel => _webSocketChannel;

  bool get isOpen => _isOpen && _webSocketChannel != null;

  Future<void> openWebsocketChannel(
  { Uri? uri,
    JsonHandler? onJson,
    BinaryHandler? onBinary,
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
    if (host == null || port == null) return;

    final isReachable = await tcpProbe(
      host,
      port,
      timeout: cfg.connectProbeTimeout,
    );

    if (!isReachable) {
      final err = SocketException(
        "Cannot reach $host:$port. Aborting WebSocket connection.",
      );
      if (kDebugMode) print(err);
      onError?.call(err.toString());
      _markClosed(onConnectionChanged);
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
                final message = jsonDecode(data);
                if (message is JsonMap) onJson?.call(message);
                break;
              case List<int>():
                final out = handleBinary(Uint8List.fromList(data));
                if (out != null) onBinary?.call(out);
                break;
              default:
                if (kDebugMode) {
                  print("Received unsupported data type: ${data.runtimeType}");
                }
                break;
            }
          } catch (e) {
            if (kDebugMode) {
              print("Error decoding message: $e");
            }
          }
        },
        onError: (error) {
          _handleStreamClosure(onConnectionChanged, onError);
        },
        onDone: () {
          if (kDebugMode)
            print("WS: onDone:: connection closed by remote or locally");
          _handleStreamClosure(onConnectionChanged, onError);
        },
        cancelOnError: true,
      );
    } catch (e, st) {
      onError?.call(e.toString(), st);
      _markClosed(onConnectionChanged);
      rethrow;
    }
  }

  void sendText(String text) {
    final ch = _webSocketChannel;
    if (ch == null) return;
    ch.sink.add(text);
  }

  Future<void> closeWebSocketChannel({bool manuallyClosed = false}) async {
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

  void _handleStreamClosure(
    ConnectionChanged? onConnectionChanged,
    ErrorHandler? onError,
  ) {
    _markClosed(onConnectionChanged);
    if (_manuallyClosed || !cfg.autoReconnect) {
      if (kDebugMode)
        print(
          "WS: Not reconnecting (manually closed: $_manuallyClosed,  autoReconnect: ${cfg.autoReconnect})",
        );
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
      print("WS: Reconnecting in ${delay.inSeconds} seconds... (attempt $_reconnectAttempts/${cfg.maxReconnectAttempts})");
    }
    maybeReconnect(
        onReconnect: () => openWebsocketChannel(),
        onError: () => onError?.call("Reconnection failed")
    );
  }

  void _markClosed(ConnectionChanged? onConnectionChanged) {
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

  void dispose() => closeWebSocketChannel(manuallyClosed: true);
}

class VidHeader {
  static const size = 24; // 4+4+8+4+2+2
  final int magic, seq, payloadLen, fpsTarget, flags;
  final int captureUs;

  VidHeader({
    required this.magic,
    required this.seq,
    required this.captureUs,
    required this.payloadLen,
    required this.fpsTarget,
    required this.flags,
  });

  static VidHeader parse(Uint8List data) {
    final bd = ByteData.sublistView(data, 0, size);
    final magic = bd.getUint32(0, Endian.little);
    final seq = bd.getUint32(4, Endian.little);
    final capLo = bd.getUint32(8, Endian.little);
    final capHi = bd.getUint32(12, Endian.little);
    final captureUs = (capHi << 32) | capLo;
    final len = bd.getUint32(16, Endian.little);
    final fps = bd.getUint16(20, Endian.little);
    final flags = bd.getUint16(22, Endian.little);
    return VidHeader(
      magic: magic,
      seq: seq,
      captureUs: captureUs,
      payloadLen: len,
      fpsTarget: fps,
      flags: flags,
    );
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

  // parse header
  if (msg.length >= VidHeader.size) {
    final hdr = VidHeader.parse(msg);
    if (hdr.magic == 0x30444956) {
      if (stats.lastSeq != null && hdr.seq != stats.lastSeq! + 1) {
        debugPrint('[VIDEO] DROPPED: prev=${stats.lastSeq} curr=${hdr.seq}');
      }
      stats.lastSeq = hdr.seq;
      final jpeg = msg.sublist(VidHeader.size, VidHeader.size + hdr.payloadLen);
      return jpeg;
    }
  }
  return null;
}
