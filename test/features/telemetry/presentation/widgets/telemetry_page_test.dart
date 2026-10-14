import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';
import 'package:mower_bot/features/telemetry/presentation/widgets/telemetry_page.dart';

class _MockTelemetryBloc extends MockBloc<TelemetryEvent, TelemetryState>
    implements TelemetryBloc {}

void main() {
  group('TelemetryPage', () {
    late _MockTelemetryBloc bloc;

    setUp(() {
      bloc = _MockTelemetryBloc();
    });

    testWidgets('renders absent telemetry age as unavailable', (tester) async {
      whenListen(
        bloc,
        const Stream<TelemetryState>.empty(),
        initialState: MegaTelemetryStatus(
          received: false,
          ageMs: null,
          ok: false,
        ),
      );

      await tester.pumpWidget(_buildPage(bloc));

      expect(find.text('Age: Unavailable'), findsOneWidget);
    });

    testWidgets('labels telemetry age in milliseconds', (tester) async {
      whenListen(
        bloc,
        const Stream<TelemetryState>.empty(),
        initialState: MegaTelemetryStatus(
          received: true,
          ageMs: 120000,
          ok: true,
        ),
      );

      await tester.pumpWidget(_buildPage(bloc));

      expect(find.text('Age: 120000 ms'), findsOneWidget);
    });
  });
}

Widget _buildPage(TelemetryBloc bloc) => MaterialApp(
  home: BlocProvider<TelemetryBloc>.value(
    value: bloc,
    child: const TelemetryPage(),
  ),
);
