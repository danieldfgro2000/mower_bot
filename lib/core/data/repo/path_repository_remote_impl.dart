import 'dart:async';

import 'package:mower_bot/core/data/network/message_envelope.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/data/repo/path_repository_impl.dart';

/// Remote implementation backed by the control WebSocket.
/// Sends path commands and awaits responses for listing.
class PathRepositoryRemote implements PathRepository {
  final IWebSocketClient _ws;
  final Duration listTimeout;

  PathRepositoryRemote(this._ws, {this.listTimeout = const Duration(seconds: 2)});

  bool get _connected => _ws.isConnected;

  Map<String, dynamic> _driveCmdEnvelope(Map<String, dynamic> inner) => {
        'topic': MessageTopic.drive.name,
        'data': inner,
      };

  @override
  Future<List<String>> fetchPaths() async {
    if (!_connected) {
      return [];
    }
    final completer = Completer<List<String>>();
    late StreamSubscription sub;
    sub = _ws.messages.listen((raw) {
      try {
        final envelope = MessageEnvelope.fromJson(raw);
        if (envelope.topic == MessageTopic.pathList) {
          final List<dynamic> rawPaths = envelope.data['paths'] as List<dynamic>? ?? const [];
          final paths = rawPaths
              .map((e) => e.toString())
              .map((name) => name.endsWith('.csv') ? name.substring(0, name.length - 4) : name)
              .toList();
          if (!completer.isCompleted) {
            completer.complete(paths);
          }
        }
      } catch (_) {
        // ignore malformed messages
      }
    });

    // Fire list request
    _ws.send(_driveCmdEnvelope({'cmd': 'list_paths'}));

    // Timeout safety
    Future.delayed(listTimeout, () {
      if (!completer.isCompleted) {
        completer.complete([]);
      }
    });

    final result = await completer.future;
    await sub.cancel();
    return result;
  }

  @override
  Future<void> playPath(String name) async {
    if (!_connected) return;
    _ws.send(_driveCmdEnvelope({'cmd': 'play_path', 'fileName': name}));
  }

  @override
  Future<void> stopPath(String name) async {
    if (!_connected) return;
    _ws.send(_driveCmdEnvelope({'cmd': 'stop_path'}));
  }

  @override
  Future<void> deletePath(String name) async {
    if (!_connected) return;
    _ws.send(_driveCmdEnvelope({'cmd': 'delete_path', 'fileName': name}));
  }
}

