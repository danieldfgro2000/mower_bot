import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// Centralized permission + capability checks used across the app.
///
/// Wi‑Fi scan results on Android require:
/// - Location permission granted
/// - Location services enabled
/// - Wi‑Fi enabled
///
/// iOS does not generally allow scanning for nearby SSIDs.
class PlatformPermissions {
  static Future<PermissionStatus> requestLocationWhenInUse() async {
    // On iOS this may show a prompt (only if Info.plist keys are present).
    return Permission.locationWhenInUse.request();
  }

  /// Returns null if Wi‑Fi scanning is possible.
  /// Otherwise returns a user-facing explanation of what’s missing.
  static Future<String?> ensureWifiScanReady() async {
    if (!Platform.isAndroid) {
      return 'Wi‑Fi scanning is not supported on this platform.';
    }

    final locationStatus = await requestLocationWhenInUse();
    if (!locationStatus.isGranted) {
      if (locationStatus.isPermanentlyDenied) {
        return 'Location permission permanently denied. Enable it in Settings to scan for the mower network.';
      }
      return 'Location permission denied. Cannot scan for the mower network.';
    }

    final can = await WiFiScan.instance.canGetScannedResults();
    if (can == CanGetScannedResults.yes) return null;

    switch (can) {
      case CanGetScannedResults.noLocationServiceDisabled:
        return 'Location services are OFF. Turn on Location (and keep Wi‑Fi on) to scan for the mower network.';
      case CanGetScannedResults.notSupported:
        return 'Wi‑Fi scanning is not supported on this device.';
      case CanGetScannedResults.noLocationPermissionDenied:
        return 'Location permission denied. Enable it to scan for the mower network.';
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
        return 'Location permission needs higher accuracy. Allow “Precise location” to scan Wi‑Fi.';
      case CanGetScannedResults.noLocationPermissionRequired:
        return 'Location permission is required to scan for the mower network.';
      case CanGetScannedResults.yes:
        return null;
    }
  }
}
