import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/platform/wifi_join_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WifiJoinService', () {
    test('connectToSsid returns false on non-Android (no platform calls)', () async {
      const channel = MethodChannel('mower_bot/wifi_network');
      final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      // If this test runs on Android, we want to know because behavior changes.
      // On macOS (typical unit tests) it should stay unhandled.
      messenger.setMockMethodCallHandler(channel, (methodCall) async {
        fail('MethodChannel should not be called on non-Android. Got: ${methodCall.method}');
      });

      final svc = WifiJoinService();
      final ok = await svc.connectToSsid('mower');
      expect(ok, isFalse);

      messenger.setMockMethodCallHandler(channel, null);
    });

    test('waitForConnectedSsid returns false on non-Android', () async {
      final svc = WifiJoinService();
      final ok = await svc.waitForConnectedSsid('mower');
      expect(ok, isFalse);
    });

    test('waitForConnectedSsid returns false when ssid is empty/blank', () async {
      final svc = WifiJoinService();

      final ok1 = await svc.waitForConnectedSsid('');
      final ok2 = await svc.waitForConnectedSsid('   ');

      expect(ok1, isFalse);
      expect(ok2, isFalse);
    });
  });
}
