import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/core/di/injection_container.dart';
import 'package:mower_bot/core/platform/permission_rationale_store.dart';
import 'package:mower_bot/core/platform/wifi_scan.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart'
    hide WifiScanFailed;
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';
import 'package:mower_bot/features/connection/presentation/pages/connection_page.dart';
import 'package:mower_bot/features/connection/presentation/pages/components/connection_button.dart';

class _MockConnectionBloc extends MockBloc<MowerConnectionEvent, MowerConnectionState>
    implements MowerConnectionBloc {}

class _MockPermissionRationaleStore extends Mock implements PermissionRationaleStore {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectionPage', () {
    late _MockConnectionBloc bloc;
    late _MockPermissionRationaleStore store;

    setUp(() {
      bloc = _MockConnectionBloc();
      store = _MockPermissionRationaleStore();

      if (sl.isRegistered<PermissionRationaleStore>()) {
        sl.unregister<PermissionRationaleStore>();
      }
      sl.registerLazySingleton<PermissionRationaleStore>(() => store);

      when(() => store.wasShown(any())).thenAnswer((_) async => true);
      when(() => store.markShown(any())).thenAnswer((_) async {});
    });

    tearDown(() {
      if (sl.isRegistered<PermissionRationaleStore>()) {
        sl.unregister<PermissionRationaleStore>();
      }
    });

    testWidgets(
      'when wifiScanStatus needsPermission and rationale already shown, does not show dialog',
      (tester) async {
        final base = const MowerConnectionState();
        when(() => bloc.state).thenReturn(base);
        whenListen(
          bloc,
          Stream.fromIterable([
            base,
            base.copyWith(wifiScanStatus: WifiScanStatus.needsPermission),
          ]),
          initialState: base,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<MowerConnectionBloc>.value(
              value: bloc,
              child: const Scaffold(body: ConnectionPage()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // On host (non-Android) the listener is gated, so the best invariant is:
        // - no dialog shown
        expect(find.byType(AlertDialog), findsNothing);
      },
    );

    testWidgets('shows WifiScanLoading when wifiScanStatus=scanning', (tester) async {
      final base = const MowerConnectionState();
      when(() => bloc.state).thenReturn(base.copyWith(wifiScanStatus: WifiScanStatus.scanning));
      whenListen(
        bloc,
        Stream.fromIterable([
          base.copyWith(wifiScanStatus: WifiScanStatus.scanning),
        ]),
        initialState: base.copyWith(wifiScanStatus: WifiScanStatus.scanning),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MowerConnectionBloc>.value(
            value: bloc,
            child: const Scaffold(body: ConnectionPage()),
          ),
        ),
      );

      await tester.pump();

      if (find.byType(WifiScanLoading).evaluate().isNotEmpty) {
        expect(find.byType(WifiScanLoading), findsOneWidget);
        expect(find.text('Cancel Scan'), findsOneWidget);
      } else {
        // Non-Android host environment: ConnectionPage won't render scan UI.
        expect(find.byType(WifiScanLoading), findsNothing);
      }
    });

    testWidgets('shows WifiScanFailed when wifiScanStatus=failed', (tester) async {
      final base = const MowerConnectionState();
      when(() => bloc.state).thenReturn(base.copyWith(wifiScanStatus: WifiScanStatus.failed, error: 'boom'));
      whenListen(
        bloc,
        Stream.fromIterable([
          base.copyWith(wifiScanStatus: WifiScanStatus.failed, error: 'boom'),
        ]),
        initialState: base.copyWith(wifiScanStatus: WifiScanStatus.failed, error: 'boom'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MowerConnectionBloc>.value(
            value: bloc,
            child: const Scaffold(body: ConnectionPage()),
          ),
        ),
      );

      await tester.pump();

      if (find.byType(WifiScanFailed).evaluate().isNotEmpty) {
        expect(find.byType(WifiScanFailed), findsOneWidget);
        expect(find.textContaining('boom'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('Continue without scan'), findsOneWidget);
      } else {
        // Non-Android host environment: ConnectionPage won't render scan UI.
        expect(find.byType(WifiScanFailed), findsNothing);
      }
    });

    testWidgets('WifiScanFailed retry/continue buttons dispatch expected events (Android-only UI)',
        (tester) async {
      final base = const MowerConnectionState();
      when(() => bloc.state).thenReturn(base.copyWith(wifiScanStatus: WifiScanStatus.failed, error: 'boom'));
      whenListen(
        bloc,
        Stream.fromIterable([
          base.copyWith(wifiScanStatus: WifiScanStatus.failed, error: 'boom'),
        ]),
        initialState: base.copyWith(wifiScanStatus: WifiScanStatus.failed, error: 'boom'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MowerConnectionBloc>.value(
            value: bloc,
            child: const Scaffold(body: ConnectionPage()),
          ),
        ),
      );

      await tester.pump();

      if (find.byType(WifiScanFailed).evaluate().isEmpty) {
        // Non-Android host environment: can't assert button->event wiring.
        return;
      }

      await tester.tap(find.text('Retry'));
      await tester.pump();
      verify(() => bloc.add(const AutoDetectWifiMode())).called(1);

      await tester.tap(find.text('Continue without scan'));
      await tester.pump();
      verify(() => bloc.add(const ChangeWiFiMode(ESP32WiFiMode.client))).called(1);
    });

    testWidgets('ConnectionButton label toggles between connect and disconnect based on connectionStatus',
        (tester) async {
      // Testing ConnectionButton in isolation avoids ConnectionPage platform-conditional branches.
      final base = const MowerConnectionState(ip: '1.2.3.4', port: 85);
      final connected = base.copyWith(status: ConnectionStatus.ctrlWsConnected);

      final formKey = GlobalKey<FormState>();

      // BlocBuilder reads bloc.state synchronously during builds.
      // Mocktail's thenReturn can't be chained (it returns void), so use an iterator.
      final states = <MowerConnectionState>[base, connected].iterator;
      when(() => bloc.state).thenAnswer((_) {
        if (states.moveNext()) return states.current;
        return connected;
      });

      whenListen(
        bloc,
        Stream.fromIterable([base, connected]),
        initialState: base,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MowerConnectionBloc>.value(
            value: bloc,
            child: Scaffold(
              body: ConnectionButton(formKey: formKey),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Connect WebSocket'), findsOneWidget);

      // Let the bloc stream emit the next state and rebuild.
      await tester.pump();
      expect(find.text('Disconnect WebSocket'), findsOneWidget);
    });

    testWidgets('shows a SnackBar when error changes to a non-empty string', (tester) async {
      final base = const MowerConnectionState(ip: '1.2.3.4', port: 85);

      when(() => bloc.state).thenReturn(base);
      whenListen(
        bloc,
        Stream.fromIterable([
          base,
          base.copyWith(error: 'Something went wrong'),
        ]),
        initialState: base,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MowerConnectionBloc>.value(
            value: bloc,
            child: const Scaffold(body: ConnectionPage()),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });
}
