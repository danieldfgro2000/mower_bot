import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/diffable_state.dart';

class MowerBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // print('📥 Event: ${bloc.runtimeType} -> $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // print('🔄 Transition: ${bloc.runtimeType} -> $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('❌ Error in ${bloc.runtimeType}: $error');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    final prev = change.currentState;
    final next = change.nextState;
    if (prev is DiffableState && next is DiffableState) {
      final diffs = StateDiffUtil.diff(prev, next);
      if (diffs.isEmpty) {
        if (kDebugMode) {
          print('📦 ${bloc.runtimeType} state change: (no field changes)');
        }
      } else {
        if (kDebugMode) {
          print('📦 ${bloc.runtimeType} state change:\n  ${diffs.join('\n  ')}');
        }
      }
    } else if (prev != next) {
      if (kDebugMode) {
        print('📦 ${bloc.runtimeType} state object changed');
      }
    }
  }
}