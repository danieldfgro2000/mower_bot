import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/diffable_state.dart';

class _SnapshotInfo {
  String lastSnapshot;
  int suppressedCount;
  _SnapshotInfo(this.lastSnapshot, this.suppressedCount);
}

class MowerBlocObserver extends BlocObserver {
  final Map<BlocBase, _SnapshotInfo> _snapshots = {};

  String _timestamp() {
    final now = DateTime.now();
    return '[${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}]';
  }

  void _printWithCollapse(BlocBase bloc, String snapshot) {
    if (!kDebugMode) return;
    final info = _snapshots[bloc];
    if (info == null) {
      _snapshots[bloc] = _SnapshotInfo(snapshot, 0);
      print('${_timestamp()} $snapshot');
      return;
    }
    if (info.lastSnapshot == snapshot) {
      // identical -> suppress
      info.suppressedCount += 1;
      return;
    }
    // different snapshot; if we suppressed earlier duplicates, emit summary first
    if (info.suppressedCount > 0) {
      print('${_timestamp()} 📦 ${bloc.runtimeType} repeated ${info.suppressedCount} identical update(s) suppressed');
      info.suppressedCount = 0;
    }
    info.lastSnapshot = snapshot;
    print('${_timestamp()} $snapshot');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // Optionally log events with timestamp if needed
    // if (kDebugMode) print('${_timestamp()} 📥 Event: ${bloc.runtimeType} -> $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // if (kDebugMode) print('${_timestamp()} 🔄 Transition: ${bloc.runtimeType} -> $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('${_timestamp()} ❌ Error in ${bloc.runtimeType}: $error');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    final prev = change.currentState;
    final next = change.nextState;
    if (prev is DiffableState && next is DiffableState) {
      final prevType = prev.runtimeType.toString();
      final nextType = next.runtimeType.toString();
      final diffs = StateDiffUtil.diff(prev, next);

      List<String> filtered = diffs;
      if (prevType == nextType) {
        filtered = filtered.where((d) => !d.startsWith('_type: ')).toList();
      }

      final newValueLines = filtered.map((d) {
        final colonIdx = d.indexOf(':');
        if (colonIdx == -1) return d; // fallback
        final field = d.substring(0, colonIdx).trim();
        final rest = d.substring(colonIdx + 1).trim();
        final arrowIdx = rest.indexOf('->');
        final newVal = arrowIdx == -1 ? rest : rest.substring(arrowIdx + 2).trim();
        if (newVal == 'null') return ''; // omit null values
        return '$field: $newVal';
      }).where((l) => l.isNotEmpty).toList();

      String snapshot;
      if (newValueLines.isEmpty) {
        if (prevType != nextType) {
          snapshot = '📦 ${bloc.runtimeType} state type -> $nextType (no field changes)';
        } else {
          snapshot = '📦 ${bloc.runtimeType} state change: (no field changes)';
        }
      } else {
        final header = prevType != nextType ? '📦 ${bloc.runtimeType} state -> $nextType' : '📦 ${bloc.runtimeType} state change';
        snapshot = '$header:  ${newValueLines.join(', ')}';
      }
      _printWithCollapse(bloc, snapshot);
    } else if (prev != next) {
      _printWithCollapse(bloc, '📦 ${bloc.runtimeType} state object changed');
    }
  }
}