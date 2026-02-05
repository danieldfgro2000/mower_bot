import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/platform/platform_settings.dart';
import 'package:mower_bot/core/platform/wifi_scan.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart'
    hide WifiScanFailed;
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

import 'components/connection_button.dart';
import 'components/connection_form.dart';
import 'components/connection_mode_header.dart';
import 'components/info.dart';
import 'components/permissions_dialog.dart';

class ConnectionPage extends StatefulWidget {
  static const String routeName = '/connection';
  final bool isVisible;

  const ConnectionPage({super.key, required this.isVisible});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final _formKey = GlobalKey<FormState>();
  late final MowerConnectionBloc connectionBloc;
  bool _permissionDialogOpen = false;

  @override
  void initState() {
    super.initState();
    connectionBloc = context.read<MowerConnectionBloc>();
    connectionBloc.add(CheckConnectionStatus());

    // Wi‑Fi SSID scanning is not generally available on iOS.
    // Only auto-detect on Android; iOS users can toggle AP/Client manually.
    if (Platform.isAndroid) {
      connectionBloc.add(const AutoDetectWifiMode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Show errors as snack bars.
        BlocListener<MowerConnectionBloc, MowerConnectionState>(
          listenWhen: (p, c) => p.error != c.error,
          listener: (context, state) {
            String? err = state.error;
            if (err == null || err.isEmpty) return;
            _showSnackBar(context, state.error!, isError: true);
          },
        ),
        /// On Android, if the Wi‑Fi scan detects that Location permission is needed,
        /// show a dialog explaining why and asking to continue to the system permission prompt.
        BlocListener<MowerConnectionBloc, MowerConnectionState>(
          listenWhen: (p, c) => p.wifiScanStatus != c.wifiScanStatus,
          listener: (context, state) async {
            if (!Platform.isAndroid || _permissionDialogOpen ||
                state.wifiScanStatus != WifiScanStatus.needsPermission) {
              return;
            }
            _permissionDialogOpen = true;
            await isLocationPermissionAccepted(context)
              ? connectionBloc.add(const WifiScanPermissionInfoAccepted())
              : connectionBloc.add(const WifiScanPermissionInfoDeclined());
            _permissionDialogOpen = false;
          },
        ),
      ],
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        maintainBottomViewPadding: true,
        child: BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
          buildWhen: (p, n) => p.wifiMode != n.wifiMode ||
              p.wifiScanStatus != n.wifiScanStatus,
          builder: (context, state) {
            bool isScanning = Platform.isAndroid &&
                state.wifiScanStatus == WifiScanStatus.scanning;
            if (isScanning) {
              return WifiScanLoading(
                onOpenWifiSettings: PlatformSettings.openWifiSettings,
                onCancel: () {
                  connectionBloc.add(const WifiScanTimedOut());
                  connectionBloc.add(const ChangeWiFiMode(ESP32WiFiMode.client));
                },
              );
            }

            bool hasScanFailed = Platform.isAndroid &&
                state.wifiScanStatus == WifiScanStatus.failed;
            if (hasScanFailed) {
              return WifiScanFailed(
                message: state.error ?? 'Wi‑Fi scan failed.',
                onOpenLocationSettings: PlatformSettings.openLocationSettings,
                onOpenWifiSettings: PlatformSettings.openWifiSettings,
                onRetry: () => connectionBloc.add(const AutoDetectWifiMode()),
                onContinue: () => connectionBloc.add(const ChangeWiFiMode(ESP32WiFiMode.client)),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ConnectionModeHeader(
                  wifiMode: state.wifiMode,
                  onModeChanged: (mode) => connectionBloc.add(ChangeWiFiMode(mode)),
                  onOpenWifiSettings: PlatformSettings.openWifiSettings,
                  onRetryScan: Platform.isAndroid
                      ? () => connectionBloc.add(const AutoDetectWifiMode())
                      : null,
                  scanStatus: state.wifiScanStatus,
                  infoBuilder: (_) => InfoWidget(),
                ),
                ConnectionForm(formKey: _formKey),
                ConnectionButton(formKey: _formKey),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

}


void _showSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red : null,
      duration: const Duration(seconds: 2),
    ),
  );
}
