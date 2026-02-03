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

class ConnectionPage extends StatefulWidget {
  static const String routeName = '/connection';

  const ConnectionPage({super.key});

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
      print('Auto-detecting Wi‑Fi mode on Android - initState');
      connectionBloc.add(const AutoDetectWifiMode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MowerConnectionBloc, MowerConnectionState>(
          listenWhen: (p, c) => p.error != c.error,
          listener: (context, state) {
            String? err = state.error;
            if (err == null || err.isEmpty) return;
            _showSnackBar(context, state.error!, isError: true);
          },
        ),
        BlocListener<MowerConnectionBloc, MowerConnectionState>(
          listenWhen: (p, c) => p.wifiScanStatus != c.wifiScanStatus,
          listener: (context, state) async {
            if (!Platform.isAndroid) return;
            if (state.wifiScanStatus != WifiScanStatus.needsPermission) return;

            if (_permissionDialogOpen) return;
            bool accepted =
                (await _showLocationPermissionDialog(context)) ?? false;
            _permissionDialogOpen = false;

            if (!context.mounted) return;
            accepted
                ? context.read<MowerConnectionBloc>().add(
                    const WifiScanPermissionInfoAccepted()
                  )
                : context.read<MowerConnectionBloc>().add(
                    const WifiScanPermissionInfoDeclined()
                  );
          },
        ),
      ],
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        maintainBottomViewPadding: true,
        child: BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
          buildWhen: (p, n) => p.wifiMode != n.wifiMode || p.wifiScanStatus != n.wifiScanStatus,
          builder: (context, state) {
            bool isScanning = Platform.isAndroid && state.wifiScanStatus == WifiScanStatus.scanning;
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
                  onModeChanged: (mode) {
                    context.read<MowerConnectionBloc>().add(
                      ChangeWiFiMode(mode),
                    );
                  },
                  onOpenWifiSettings: PlatformSettings.openWifiSettings,
                  onRetryScan: Platform.isAndroid
                      ? () => context.read<MowerConnectionBloc>().add(
                          const AutoDetectWifiMode(ssidPrefix: 'mower'),
                        )
                      : null,
                  scanStatus: state.wifiScanStatus,
                  infoBuilder: (ctx) => const Text(
                    'Some phones still require a manual confirm in Wi‑Fi settings. '
                    'The phone will not automatically connect to the MowerBot network\n\n'
                    'In this case, follow these steps:\n'
                    '1) Open Wi‑Fi settings and connect to the MowerBot-AP network\n'
                    '2) Come back and tap “Connect WebSocket”\n'
                    '3) The status in the upper part of the screen will show "Connected"\n',
                  ),
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

  Future<bool?> _showLocationPermissionDialog(BuildContext context) async {
    _permissionDialogOpen = true;
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Location permission needed'),
          content: const Text(
            'Android requires Location permission to scan nearby Wi‑Fi network names (SSIDs).\n\n'
            'We only use this to detect the mower Wi‑Fi network automatically. '
            'We do not track or store your location.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
    return accepted;
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
