import 'dart:async';
import 'dart:developer' as dev;

import 'package:mower_bot/core/data/network/message_envelope.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/data/repo/path_repository_impl.dart';

const _tag = 'PathRepo';

/// Remote implementation backed by the control WebSocket.
/// Sends path commands and awaits responses for listing.
class PathRepositoryRemote implements PathRepository {
  final IWebSocketClient _ws;
  final Duration listTimeout;

  PathRepositoryRemote(this._ws, {this.listTimeout = const Duration(seconds: 4)}) {
    // Passively log any pathDiag messages that arrive (e.g. after requestDiag())
    _ws.messages.listen((raw) {
      try {
        final envelope = MessageEnvelope.fromJson(raw);
        if (envelope.topic == MessageTopic.pathDiag) {
          final d = envelope.data;
          dev.log(
            '[$_tag][DIAG] SD=${d['sdOk']}  '
            '${d['sdUsedMB']}/${d['sdTotalMB']} MB used  '
            'free=${d['sdFreeMB']} MB  '
            'paths=${d['pathCount']}  '
            'rec=${d['isRecording']}  play=${d['isPlaying']}',
            name: _tag,
          );
          dev.log(
            '[$_tag][DIAG] recSamples=${d['recordSampleCount']} '
            'temp=${d['recordTempFile']} '
            'lastSaved=${d['recordLastSavedFile']} '
            'recErr=${d['recordLastError']}',
            name: _tag,
          );
          dev.log(
            '[$_tag][DIAG] playSamples=${d['playSampleCount']} '
            'malformed=${d['playMalformedCount']} '
            'active=${d['playActiveFile']} '
            'playErr=${d['playLastError']}',
            name: _tag,
          );
          final paths = d['paths'] as List<dynamic>? ?? [];
          for (final p in paths) {
            dev.log(
              '[$_tag][DIAG]   • ${p['name']}  ${p['sizeBytes']} B  ~${p['estSamples']} samples',
              name: _tag,
            );
          }
        }
      } catch (_) {}
    });
  }

  bool get _connected => _ws.isConnected;

  /// Logs a warning when the WebSocket is not connected and returns true if
  /// the caller should abort (i.e. not connected).
  bool _guardConnected(String op) {
    if (!_connected) {
      dev.log('[$_tag] $op skipped — WebSocket not connected', name: _tag);
      return true;
    }
    return false;
  }

  Map<String, dynamic> _driveCmdEnvelope(Map<String, dynamic> inner) => {
        'topic': MessageTopic.drive.name,
        'data': inner,
      };

  @override
  Future<List<String>> fetchPaths() async {
    if (_guardConnected('fetchPaths')) return [];

    dev.log('[$_tag] fetchPaths → sending list_paths request', name: _tag);

    final completer = Completer<List<String>>();
    late StreamSubscription sub;

    sub = _ws.messages.listen((raw) {
      try {
        final envelope = MessageEnvelope.fromJson(raw);
        if (envelope.topic == MessageTopic.pathList) {
          final List<dynamic> rawPaths =
              envelope.data['paths'] as List<dynamic>? ?? const [];
          final paths = rawPaths
              .map((e) => e.toString())
              .map((n) => n.endsWith('.csv') ? n.substring(0, n.length - 4) : n)
              .toList();
          dev.log('[$_tag] fetchPaths ← received ${paths.length} path(s): $paths',
              name: _tag);
          if (!completer.isCompleted) completer.complete(paths);
        }
      } catch (e) {
        dev.log('[$_tag] fetchPaths — malformed message ignored: $e', name: _tag);
      }
    });

    _ws.send(_driveCmdEnvelope({'cmd': 'list_paths'}));

    Future.delayed(listTimeout, () {
      if (!completer.isCompleted) {
        dev.log('[$_tag] fetchPaths — timed out after ${listTimeout.inSeconds}s, returning []',
            name: _tag);
        completer.complete([]);
      }
    });

    final result = await completer.future;
    await sub.cancel();
    return result;
  }

  @override
  Future<void> playPath(String name) async {
    if (_guardConnected('playPath')) return;
    if (name.isEmpty) {
      dev.log('[$_tag] playPath — name is empty, ignored', name: _tag);
      return;
    }
    dev.log('[$_tag] playPath → "$name"', name: _tag);
    _ws.send(_driveCmdEnvelope({'cmd': 'play_path', 'fileName': name}));
  }

  @override
  Future<void> stopPath(String name) async {
    if (_guardConnected('stopPath')) return;
    dev.log('[$_tag] stopPath → stop playback', name: _tag);
    _ws.send(_driveCmdEnvelope({'cmd': 'stop_path'}));
  }

  @override
  Future<void> startRecord() async {
    if (_guardConnected('startRecord')) return;
    dev.log('[$_tag] startRecord → sending start_record', name: _tag);
    _ws.send(_driveCmdEnvelope({'cmd': 'start_record'}));
  }

  @override
  Future<void> stopRecord(String name) async {
    if (_guardConnected('stopRecord')) return;
    if (name.isEmpty) {
      dev.log('[$_tag] stopRecord — empty name, sending discard (fileName="")',
          name: _tag);
      // Empty fileName tells ESP32 to delete the temp file (discard)
      _ws.send(_driveCmdEnvelope({'cmd': 'stop_record', 'fileName': ''}));
      return;
    }
    dev.log('[$_tag] stopRecord → saving as "$name"', name: _tag);
    _ws.send(_driveCmdEnvelope({'cmd': 'stop_record', 'fileName': name}));
  }

  @override
  Future<void> deletePath(String name) async {
    if (_guardConnected('deletePath')) return;
    if (name.isEmpty) {
      dev.log('[$_tag] deletePath — name is empty, ignored', name: _tag);
      return;
    }
    dev.log('[$_tag] deletePath → "$name"', name: _tag);
    _ws.send(_driveCmdEnvelope({'cmd': 'delete_path', 'fileName': name}));
  }
}
