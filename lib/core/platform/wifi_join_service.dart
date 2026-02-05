import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';

/// Best-effort helper to programmatically join the mower AP on Android.
///
/// Notes:
/// - On newer Android versions, the OS may limit silent Wi‑Fi joins.
/// - If this fails, the UI should fall back to opening Wi‑Fi Settings.
class WifiJoinService {
  static const MethodChannel _channel = MethodChannel('mower_bot/wifi_network');

  Future<bool> connectToSsid(
    String ssid, {
    String? password,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (!Platform.isAndroid) return false;

    try {
      // Some devices require quotes around SSID; the plugin handles this internally.
      final hasConnected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        joinOnce: false,
        security: NetworkSecurity.WPA,
        withInternet: false,
      );

      print('WiFiForIoTPlugin.connect returned: $hasConnected');

      if (hasConnected != true) return false;

      // Wait until we're actually on that SSID AND the OS has finalized the network
      // (i.e. we have a Wi‑Fi interface and an IP). This avoids racing the websocket.
      final joined = await waitForConnectedSsid(ssid, timeout: timeout);
      if (!joined) return false;

      // Ensure sockets are routed over the joined Wi‑Fi network.
      return await _bindToWifiNetwork();
    } catch (e) {
      if (kDebugMode) print('WifiJoinService.connectToSsid error: $e');
      return false;
    }
  }

  Future<bool> _bindToWifiNetwork() async {
    try {
      final ok = await _channel.invokeMethod<bool>('bindToWifiNetwork');
      if (ok == true) return true;
      if (kDebugMode) print('WifiJoinService: bindToWifiNetwork returned false');
      return false;
    } catch (e) {
      if (kDebugMode) print('WifiJoinService: bindToWifiNetwork error: $e');
      return false;
    }
  }

  /// Waits until Android reports we're connected to [ssid].
  ///
  /// This is useful because the OS association can lag behind a successful
  /// connect() call, and we want to avoid attempting the mower websocket too early.
  Future<bool> waitForConnectedSsid(
    String ssid, {
    Duration timeout = const Duration(seconds: 15),
    Duration pollInterval = const Duration(milliseconds: 250),
  }) async {
    if (!Platform.isAndroid) return false;

    final target = ssid.trim();
    if (target.isEmpty) return false;

    try {
      final deadline = DateTime.now().add(timeout);
      while (DateTime.now().isBefore(deadline)) {
        final current = await WiFiForIoTPlugin.getSSID();
        final normalized = _normalizeSsid(current);
        if (normalized == target) {
          // On some devices getSSID flips early, before the network is usable.
          // Gate on "we actually have a local IP" as well.
          if (await _hasWifiLocalIp()) return true;
        }
        await Future<void>.delayed(pollInterval);
      }
      return false;
    } catch (e) {
      if(kDebugMode) print('WIFI joining error: $e');
      return false;
    }
  }

  Future<bool> _hasWifiLocalIp() async {
    try {
      final ip = await WiFiForIoTPlugin.getIP();
      if (ip == null) return false;
      final s = ip.trim();
      if (s.isEmpty) return false;
      print('WIFI joined IP: $s');
      // Some implementations return 0.0.0.0 while still connecting.
      if (s == '0.0.0.0') return false;
      // Basic IPv4 shape check.
      return RegExp(r'^\d{1,3}(?:\.\d{1,3}){3}$').hasMatch(s);
    } catch (e) {
      if(kDebugMode) print('WIFI joining read IP error: $e');
      return false;
    }
  }

  String? _normalizeSsid(String? raw) {
    if (raw == null) return null;
    final s = raw.trim();
    if (s.startsWith('"') && s.endsWith('"') && s.length >= 2) {
      return s.substring(1, s.length - 1);
    }
    return s;
  }
}
