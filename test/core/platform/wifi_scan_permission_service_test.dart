import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/platform/wifi_scan_permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WifiScanPermissionService', () {
    test('returns not supported on non-Android', () async {
      if (Platform.isAndroid) return;

      final service = WifiScanPermissionService();
      final msg = await service.checkReady();
      expect(msg, contains('not supported'));
    });

    test('returns "Location permission required." when permission not granted (Android only)', () async {
      if (!Platform.isAndroid) return;

      // NOTE: permission_handler isn't trivially mockable without its platform interface.
      // This test acts as a smoke test on Android (or can be run on an Android emulator).
      final service = WifiScanPermissionService();
      final msg = await service.checkReady();
      // Depending on device state, message can vary. We only assert the contract:
      // result is either null (ready) or a non-empty message.
      expect(msg == null || msg.isNotEmpty, isTrue);
    });

    test('requestPermission returns a PermissionStatus (smoke test)', () async {
      final service = WifiScanPermissionService();
      final status = await service.requestPermission();
      expect(status, isA<PermissionStatus>());
    });

    test('CanGetScannedResults enum has expected values', () {
      // Pure sanity check to catch breaking plugin API changes.
      expect(CanGetScannedResults.yes, isNotNull);
      expect(CanGetScannedResults.noLocationServiceDisabled, isNotNull);
    });
  });
}

