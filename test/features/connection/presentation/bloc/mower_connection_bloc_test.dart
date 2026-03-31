import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import '../../../../test_helpers/mocks.dart';
import 'package:permission_handler/permission_handler.dart';

class _FakeTelemetryEvent extends Fake implements TelemetryEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(_FakeTelemetryEvent());
  });

  group('MowerConnectionBloc', () {
    late MockConnectToCtrlWsUseCase connect;
    late MockDisconnectCtrlWsUseCase disconnect;
    late MockCheckCtrlWsConnectedUseCase check;
    late MockTelemetryBloc telemetryBloc;
    late MockMowerConnectionRepository repo;
    late MockWifiScanPermissionService perm;
    late MockWifiJoinService join;
    late MockMowerReachabilityService reachability;

    late StreamController<ConnectionStatus> ctrlWsController;
    late StreamController<dynamic> errController;

    setUp(() {
      connect = MockConnectToCtrlWsUseCase();
      disconnect = MockDisconnectCtrlWsUseCase();
      check = MockCheckCtrlWsConnectedUseCase();
      telemetryBloc = MockTelemetryBloc();
      repo = MockMowerConnectionRepository();
      perm = MockWifiScanPermissionService();
      join = MockWifiJoinService();
      reachability = MockMowerReachabilityService();

      ctrlWsController = StreamController<ConnectionStatus>.broadcast();
      errController = StreamController.broadcast();

      when(() => repo.ctrlWsConnected()).thenAnswer((_) => ctrlWsController.stream);
      when(() => repo.ctrlWsErr()).thenAnswer((_) => errController.stream.cast());
      when(() => repo.isCtrlWsConnected).thenReturn(false);

      when(() => telemetryBloc.add(any())).thenReturn(null);

      // Default: permission ready unless overridden
      when(() => perm.checkReady()).thenAnswer((_) async => null);
      when(() => perm.requestPermission()).thenAnswer((_) async => PermissionStatus.granted);
      when(() => perm.isPermanentlyDenied()).thenAnswer((_) async => false);

      // Default connect succeeds
      when(() => connect(any(), any())).thenAnswer((_) async {});
      when(() => disconnect()).thenAnswer((_) async {});
      when(() => check()).thenReturn(false);

      // Default join/reachability succeed
      when(() => join.connectToSsid(any(), password: any(named: 'password')))
          .thenAnswer((_) async => true);
      when(() => reachability.waitUntilReachable(any())).thenAnswer((_) async => true);
    });

    tearDown(() async {
      await ctrlWsController.close();
      await errController.close();
    });

    MowerConnectionBloc buildBloc() => MowerConnectionBloc(
          connect,
          disconnect,
          check,
          telemetryBloc,
          repo,
          perm,
          join,
          reachability,
        );

    blocTest<MowerConnectionBloc, MowerConnectionState>(
      'AutoDetectWifiMode emits needsPermission when permission service says it is required',
      build: () {
        when(() => perm.checkReady()).thenAnswer((_) async => 'Location permission required.');
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AutoDetectWifiMode(timeout: Duration(milliseconds: 50))),
      expect: () => [
        isA<MowerConnectionState>().having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.idle),
        isA<MowerConnectionState>().having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.scanning),
        isA<MowerConnectionState>().having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.needsPermission),
      ],
    );

    blocTest<MowerConnectionBloc, MowerConnectionState>(
      'WifiScanPermissionInfoAccepted -> denied + permanentlyDenied false emits failed with denied message',
      build: () {
        when(() => perm.requestPermission()).thenAnswer((_) async => PermissionStatus.denied);
        when(() => perm.isPermanentlyDenied()).thenAnswer((_) async => false);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const WifiScanPermissionInfoAccepted()),
      expect: () => [
        isA<MowerConnectionState>().having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.idle),
        isA<MowerConnectionState>()
            .having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.failed)
            .having((s) => s.error, 'error', contains('denied')),
      ],
    );

    blocTest<MowerConnectionBloc, MowerConnectionState>(
      'WifiScanPermissionInfoAccepted -> denied + permanentlyDenied true emits failed with permanently denied message',
      build: () {
        when(() => perm.requestPermission()).thenAnswer((_) async => PermissionStatus.permanentlyDenied);
        when(() => perm.isPermanentlyDenied()).thenAnswer((_) async => true);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const WifiScanPermissionInfoAccepted()),
      expect: () => [
        isA<MowerConnectionState>().having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.idle),
        isA<MowerConnectionState>()
            .having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.failed)
            .having((s) => s.error, 'error', contains('permanently denied')),
      ],
    );

    test('WifiScanDetectedAp starts a connect attempt (connect use case invoked, connecting state emitted)', () async {
      final bloc = buildBloc();
      addTearDown(bloc.close);

      final states = <MowerConnectionState>[];
      final sub = bloc.stream.listen(states.add);
      addTearDown(sub.cancel);

      bloc.add(const WifiScanDetectedAp(ssid: 'MowerBot-AP'));

      // allow async chain (auto-connect -> ws connect) to run
      await Future<void>.delayed(const Duration(milliseconds: 50));

      verify(() => connect('192.168.4.1', 85)).called(greaterThanOrEqualTo(1));
      expect(states.any((s) => s.connectionStatus == ConnectionStatus.connecting), isTrue);
      expect(states.any((s) => s.wifiMode == ESP32WiFiMode.ap && s.wifiScanStatus == WifiScanStatus.completed), isTrue);
    });

    blocTest<MowerConnectionBloc, MowerConnectionState>(
      'AutoDetectWifiMode emits failed when permission service returns a non-permission readiness error',
      build: () {
        when(() => perm.checkReady()).thenAnswer((_) async => 'Location services are OFF.');
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AutoDetectWifiMode(timeout: Duration(milliseconds: 50))),
      expect: () => [
        isA<MowerConnectionState>()
            .having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.idle),
        isA<MowerConnectionState>()
            .having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.scanning),
        isA<MowerConnectionState>()
            .having((s) => s.wifiScanStatus, 'wifiScanStatus', WifiScanStatus.failed)
            .having((s) => s.error, 'error', contains('Location services are OFF')),
      ],
    );

    // TODO: WiFiScan.instance is a plugin singleton and can't be stubbed via mocktail
    // here. The WiFiScan.startScan failure path is better covered in an integration
    // test or after introducing a small injectable WiFiScan adapter.

    // Remove/disable the startScan=false unit test (kept as a TODO).

    test('AutoConnectToMower in client mode triggers a WS connect attempt (connect use case invoked)',
        () async {
      final bloc = buildBloc();
      addTearDown(bloc.close);

      final states = <MowerConnectionState>[];
      final sub = bloc.stream.listen(states.add);
      addTearDown(sub.cancel);

      bloc.add(const ChangeWiFiMode(ESP32WiFiMode.client));
      bloc.add(const ChangeIp('10.0.0.2'));
      bloc.add(const ChangePort(1234));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      bloc.add(const AutoConnectToMower());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      verify(() => connect('10.0.0.2', 1234)).called(1);
      expect(states.any((s) => s.connectionStatus == ConnectionStatus.connecting), isTrue);
    });

    test('AutoConnectToMower in AP mode: join fails -> probes reachability, emits hostUnreachable, no ws connect',
        () async {
      when(() => join.connectToSsid(any(), password: any(named: 'password')))
          .thenAnswer((_) async => false);
      when(() => reachability.waitUntilReachable(any())).thenAnswer((_) async => false);

      final bloc = buildBloc();
      addTearDown(bloc.close);

      final states = <MowerConnectionState>[];
      final sub = bloc.stream.listen(states.add);
      addTearDown(sub.cancel);

      bloc.add(const WifiScanDetectedAp(ssid: 'MowerBot-AP'));
      await Future<void>.delayed(const Duration(milliseconds: 80));

      // Current bloc implementation: if join fails, it still probes reachability.
      verify(() => reachability.waitUntilReachable(any())).called(greaterThanOrEqualTo(1));
      verifyNever(() => connect(any(), any()));
      expect(states.any((s) => s.connectionStatus == ConnectionStatus.hostUnreachable), isTrue);
    });

    test('AutoConnectToMower in AP mode: join ok but reachability fails -> hostUnreachable and no ws connect',
        () async {
      when(() => join.connectToSsid(any(), password: any(named: 'password')))
          .thenAnswer((_) async => true);
      when(() => reachability.waitUntilReachable(any())).thenAnswer((_) async => false);

      final bloc = buildBloc();
      addTearDown(bloc.close);

      final states = <MowerConnectionState>[];
      final sub = bloc.stream.listen(states.add);
      addTearDown(sub.cancel);

      bloc.add(const WifiScanDetectedAp(ssid: 'MowerBot-AP'));
      await Future<void>.delayed(const Duration(milliseconds: 80));

      verify(() => reachability.waitUntilReachable(any())).called(1);
      verifyNever(() => connect(any(), any()));
      expect(states.any((s) => s.connectionStatus == ConnectionStatus.hostUnreachable), isTrue);
    });

    test('AutoConnectToMower is guarded against overlaps (connect called once)', () async {
      final bloc = buildBloc();
      addTearDown(bloc.close);

      bloc.add(const WifiScanDetectedAp(ssid: 'MowerBot-AP'));
      bloc.add(const AutoConnectToMower());
      bloc.add(const AutoConnectToMower());

      await Future<void>.delayed(const Duration(milliseconds: 120));
      verify(() => connect('192.168.4.1', 85)).called(1);
    });
  });
}
