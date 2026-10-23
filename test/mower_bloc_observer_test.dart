import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';
import 'package:mower_bot/mower_bloc_observer.dart';

class _ConnectionCubit extends Cubit<MowerConnectionState> {
  _ConnectionCubit(super.initialState);
}

void main() {
  test('connection state changes do not log AP credentials', () async {
    const previousCredential = 'test-credential-before';
    const nextCredential = 'test-credential-after';
    const previous = MowerConnectionState(apPassword: previousCredential);
    const next = MowerConnectionState(
      wifiMode: ESP32WiFiMode.ap,
      apPassword: nextCredential,
    );
    final bloc = _ConnectionCubit(previous);
    final logs = <String>[];

    runZoned(
      () => MowerBlocObserver().onChange(
        bloc,
        const Change<MowerConnectionState>(
          currentState: previous,
          nextState: next,
        ),
      ),
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, line) => logs.add(line),
      ),
    );

    final output = logs.join('\n');
    expect(output, contains('wifiMode: ESP32WiFiMode.ap'));
    expect(output, isNot(contains(previousCredential)));
    expect(output, isNot(contains(nextCredential)));

    await bloc.close();
  });
}
