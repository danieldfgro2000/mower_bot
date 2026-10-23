import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// A small, testable service that decides whether Wi‑Fi SSID scanning is possible
/// and (optionally) triggers the Android permission prompt.
///
/// IMPORTANT: On Android, scanning nearby Wi‑Fi SSIDs is gated behind Location
/// permission and Location services.
class WifiScanPermissionService {
  // coverage:ignore-start
  WifiScanPermissionService({
    bool Function()? isAndroid,
    Future<PermissionStatus> Function()? getLocationStatus,
    Future<PermissionStatus> Function()? requestLocation,
    Future<CanGetScannedResults> Function()? canGetScannedResults,
  })  : _isAndroid = isAndroid ?? (() => Platform.isAndroid),
        _getLocationStatus =
            getLocationStatus ?? (() => Permission.locationWhenInUse.status),
        _requestLocation =
            requestLocation ?? (() => Permission.locationWhenInUse.request()),
        _canGetScannedResults =
            canGetScannedResults ?? (() => WiFiScan.instance.canGetScannedResults());
  // coverage:ignore-end

  final bool Function() _isAndroid;
  final Future<PermissionStatus> Function() _getLocationStatus;
  final Future<PermissionStatus> Function() _requestLocation;
  final Future<CanGetScannedResults> Function() _canGetScannedResults;

  /// Returns `null` if scanning is possible *without requesting anything*.
  /// Otherwise returns a user-facing error message.
  Future<String?> checkReady() async {
    if (!_isAndroid()) {
      return 'Wi‑Fi scanning is not supported on this platform.';
    }

    final locationStatus = await _getLocationStatus();
    if (!locationStatus.isGranted) {
      // Not granted yet -> let caller decide whether to show an explanation
      // dialog and request it.
      return 'Location permission required.';
    }

    final can = await _canGetScannedResults();
    if (can == CanGetScannedResults.yes) return null;

    switch (can) {
      case CanGetScannedResults.noLocationServiceDisabled:
        return 'Location services are OFF. Turn on Location (and keep Wi‑Fi on) to scan for the mower network.';
      case CanGetScannedResults.notSupported:
        return 'Wi‑Fi scanning is not supported on this device.';
      case CanGetScannedResults.noLocationPermissionDenied:
      case CanGetScannedResults.noLocationPermissionRequired:
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
        return 'Location permission required.';
      case CanGetScannedResults.yes:
        return null;
    }
  }

  /// Returns the resulting permission status after prompting.
  Future<PermissionStatus> requestPermission() async {
    if (!_isAndroid()) {
      return PermissionStatus.denied;
    }
    return _requestLocation();
  }

  Future<bool> isPermanentlyDenied() async {
    final s = await _getLocationStatus();
    return s.isPermanentlyDenied;
  }
}
