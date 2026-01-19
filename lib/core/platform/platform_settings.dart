import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
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
      } catch (_) {
        // Fall through to other options.
      }

      // Fallback: try app_settings (may open Wi‑Fi settings depending on OEM).
      try {
        AppSettings.openAppSettings(type: AppSettingsType.wifi);
        return;
      } catch (_) {
        // ignore
      }

      // Last resort: open Settings root.
      try {
        AppSettings.openAppSettings();
      } catch (_) {}
      return;
    }

    if (Platform.isIOS) {
      // iOS: best effort. This usually opens Settings (sometimes directly to Wi‑Fi depending on iOS version).
      final uri = Uri.parse('App-Prefs:WIFI');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }

      // Fallback: app settings.
      try {
        AppSettings.openAppSettings();
      } catch (_) {}
      return;
    }

    // Other platforms
    try {
      AppSettings.openAppSettings();
    } catch (_) {}
  }

  static Future<void> openLocationSettings() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod<void>('openLocationSettings');
        return;
      } catch (_) {
        // fall through
      }
      try {
        AppSettings.openAppSettings(type: AppSettingsType.location);
        return;
      } catch (_) {}
      try {
        AppSettings.openAppSettings();
      } catch (_) {}
      return;
    }

    // Other platforms: best-effort.
    try {
      AppSettings.openAppSettings();
    } catch (_) {}
  }
}
