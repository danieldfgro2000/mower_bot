import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helpers to open platform settings screens.
///
/// Notes:
/// - iOS does not allow opening the Wi‑Fi picker directly; the best we can do is deep-link to settings.
/// - Android supports opening the Wi‑Fi panel via intent.
class PlatformSettings {
  static const MethodChannel _channel = MethodChannel('mower_bot/platform_settings');

  static Future<void> openWifiSettings() async {
    if (Platform.isAndroid) {
      // Prefer native Android intent (Settings.Panel.ACTION_WIFI) for a real Wi‑Fi picker.
      try {
        await _channel.invokeMethod<void>('openWifiPanel');
        return;
      } catch (e) {
        if(kDebugMode) print('Failed to open Wi‑Fi panel via native intent: $e');
      }
      // Fallback: try app_settings (may open Wi‑Fi settings depending on OEM).
      try {
        AppSettings.openAppSettings(type: AppSettingsType.wifi);
        return;
      } catch (e) {
        if(kDebugMode) print('Failed to open Wi‑Fi settings via app_settings: $e');
      }
      // Last resort: open Settings root.
      try {
        AppSettings.openAppSettings();
      } catch (e) {
        if(kDebugMode) print('Failed to open App settings via app_settings: $e');
      }
      return;
    }

    if (Platform.isIOS) {
      // iOS: best effort. This usually opens Settings (sometimes directly to Wi‑Fi depending on iOS version).
      final uri = Uri.parse('App-Prefs:WIFI');
      if (await canLaunchUrl(uri)) {
        if (kDebugMode) {
          print('Opening iOS Wi‑Fi settings via deep link: $uri');
        }
        await launchUrl(uri);
        return;
      }

      // Fallback: app settings.
      try {
        print('Falling back to opening App settings on iOS');
        AppSettings.openAppSettings(type: AppSettingsType.wifi);
      } catch (e) {
        if(kDebugMode) print('Failed to open App settings via app_settings: $e');
      }
      return;
    }

    // Other platforms
    try {
      AppSettings.openAppSettings();
    } catch (e) {
      if(kDebugMode) print('Failed to open App settings via app_settings: $e');
    }
  }

  static Future<void> openLocationSettings() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod<void>('openLocationSettings');
        return;
      } catch (e) {
        if(kDebugMode) print('Failed to open Location settings via native intent: $e');
      }
      try {
        AppSettings.openAppSettings(type: AppSettingsType.location);
        return;
      } catch (e) {
        if(kDebugMode) print('Failed to open Location settings via app_settings: $e');
      }
      try {
        AppSettings.openAppSettings();
      } catch (e) {
        if(kDebugMode) print('Failed to open App settings via app_settings: $e');
      }
      return;
    }

    // Other platforms: best-effort.
    try {
      AppSettings.openAppSettings();
    } catch (e) {
      if(kDebugMode) print('Failed to open App settings via app_settings: $e');
    }
  }

  /// Opens an appropriate screen for fixing Location requirements.
  ///
  /// - If the app's location permission is denied/permanently denied/restricted,
  ///   open the app-specific settings page so the user can grant it.
  /// - If permission is already granted, open the system Location toggle settings.
  static Future<void> openLocationOrAppPermissionSettings() async {
    try {
      final status = await Permission.locationWhenInUse.status;
      if (!status.isGranted) {
        // AppSettingsType.location often goes to the global location screen,
        // but in this case we want *app* permission settings.
        await openAppPermissionSettings();
        return;
      }
    } catch (e) {
      if (kDebugMode) print('Failed to check location permission status: $e');
      // Fall through to default behavior.
    }

    await openLocationSettings();
  }

  static Future<void> openAppPermissionSettings() async {
    // permission_handler provides the most reliable deep link.
    try {
      final ok = await openAppSettings();
      if (ok) return;
    } catch (e) {
      if (kDebugMode) print('Failed to open app settings via permission_handler: $e');
    }

    // Fallback
    try {
      AppSettings.openAppSettings();
    } catch (e) {
      if (kDebugMode) print('Failed to open app settings via app_settings: $e');
    }
  }
}
