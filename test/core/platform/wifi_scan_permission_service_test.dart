import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/platform/wifi_scan_permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WifiScanPermissionService', () {
    test('checkReady returns not supported on non-Android', () async {
      final service = WifiScanPermissionService(isAndroid: () => false);
      final msg = await service.checkReady();
      expect(msg, contains('not supported'));
    });

    test('checkReady returns permission required when location is not granted', () async {
      final service = WifiScanPermissionService(
        isAndroid: () => true,
        getLocationStatus: () async => PermissionStatus.denied,
        canGetScannedResults: () async => CanGetScannedResults.yes,
      );

      expect(await service.checkReady(), 'Location permission required.');
    });

    test('checkReady returns null when canGetScannedResults is yes', () async {
      final service = WifiScanPermissionService(
        isAndroid: () => true,
        getLocationStatus: () async => PermissionStatus.granted,
        canGetScannedResults: () async => CanGetScannedResults.yes,
      );

      expect(await service.checkReady(), isNull);
    });

    test('checkReady maps scanner capability errors to user messages', () async {
      Future<String?> call(CanGetScannedResults can) {
        return WifiScanPermissionService(
          isAndroid: () => true,
          getLocationStatus: () async => PermissionStatus.granted,
          canGetScannedResults: () async => can,
        ).checkReady();
      }

      expect(
        await call(CanGetScannedResults.noLocationServiceDisabled),
        contains('Location services are OFF'),
      );
      expect(
        await call(CanGetScannedResults.notSupported),
        contains('not supported on this device'),
      );
      expect(
        await call(CanGetScannedResults.noLocationPermissionDenied),
        'Location permission required.',
      );
      expect(
        await call(CanGetScannedResults.noLocationPermissionRequired),
        'Location permission required.',
      );
      expect(
        await call(CanGetScannedResults.noLocationPermissionUpgradeAccuracy),
        'Location permission required.',
      );
    });

    test('requestPermission returns denied on non-Android', () async {
      final service = WifiScanPermissionService(isAndroid: () => false);
      expect(await service.requestPermission(), PermissionStatus.denied);
    });

    test('requestPermission delegates to injected requestLocation on Android', () async {
      var called = 0;
      final service = WifiScanPermissionService(
        isAndroid: () => true,
        requestLocation: () async {
          called++;
          return PermissionStatus.granted;
        },
      );

      expect(await service.requestPermission(), PermissionStatus.granted);
      expect(called, 1);
    });

    test('isPermanentlyDenied returns true when status is permanentlyDenied', () async {
      final service = WifiScanPermissionService(
        isAndroid: () => true,
        getLocationStatus: () async => PermissionStatus.permanentlyDenied,
      );

      expect(await service.isPermanentlyDenied(), isTrue);
    });

    test('isPermanentlyDenied returns false when status is denied/granted', () async {
      final denied = WifiScanPermissionService(
        isAndroid: () => true,
        getLocationStatus: () async => PermissionStatus.denied,
      );
      final granted = WifiScanPermissionService(
        isAndroid: () => true,
        getLocationStatus: () async => PermissionStatus.granted,
      );

      expect(await denied.isPermanentlyDenied(), isFalse);
      expect(await granted.isPermanentlyDenied(), isFalse);
    });

    test('checkReady does not call canGetScannedResults when permission not granted', () async {
      var canCalls = 0;
      final service = WifiScanPermissionService(
        isAndroid: () => true,
        getLocationStatus: () async => PermissionStatus.denied,
        canGetScannedResults: () async {
          canCalls++;
          return CanGetScannedResults.yes;
        },
      );

      expect(await service.checkReady(), 'Location permission required.');
      expect(canCalls, 0);
    });

    test('requestPermission on Android calls requestLocation and returns its status', () async {
      var requestCalls = 0;
      final service = WifiScanPermissionService(
        isAndroid: () => true,
        requestLocation: () async {
          requestCalls++;
          return PermissionStatus.denied;
        },
      );

      expect(await service.requestPermission(), PermissionStatus.denied);
      expect(requestCalls, 1);
    });
  });
}
