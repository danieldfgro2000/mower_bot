import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/platform/platform_settings.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

import 'components/connection_button.dart';
import 'components/connection_form.dart';

class ConnectionPage extends StatefulWidget {
  static const String routeName = '/connection';

  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MowerConnectionBloc>();
    bloc.add(CheckConnectionStatus());

    // Wi‑Fi SSID scanning is not generally available on iOS.
    // Only auto-detect on Android; iOS users can toggle AP/Client manually.
    if (Platform.isAndroid) {
      bloc.add(const AutoDetectWifiMode(ssidPrefix: 'mower'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenOrientation = MediaQuery.of(context).orientation;

    return MultiBlocListener(
      listeners: [
        BlocListener<MowerConnectionBloc, MowerConnectionState>(
          listenWhen: (p, c) => p.error != c.error,
          listener: (context, state) {
            String? err = state.error;
            if (err == null || err.isEmpty) return;
            _showSnackBar(context, state.error!, isError: true);
          },
        )
      ],
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        maintainBottomViewPadding: true,
        child: BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
          buildWhen: (p, n) => p.wifiMode != n.wifiMode || p.wifiScanStatus != n.wifiScanStatus,
          builder: (context, state) {
            // Loading screen while scanning for the mower AP SSID.
            if (Platform.isAndroid && state.wifiScanStatus == WifiScanStatus.scanning) {
              return _WifiScanLoading(
                onOpenWifiSettings: () => PlatformSettings.openWifiSettings(),
              );
            }

            // Scan failed: show guidance + quick actions on Android.
            if (Platform.isAndroid && state.wifiScanStatus == WifiScanStatus.failed) {
              final err = (state.error ?? '').toLowerCase();
              final locationOff = err.contains('location services are off');

              return _WifiScanFailed(
                message: state.error ?? 'Wi‑Fi scan failed.',
                onOpenLocationSettings: locationOff ? () => PlatformSettings.openLocationSettings() : null,
                onOpenWifiSettings: () => PlatformSettings.openWifiSettings(),
                onRetry: () => context.read<MowerConnectionBloc>().add(const AutoDetectWifiMode(ssidPrefix: 'mower')),
                onContinue: () => context.read<MowerConnectionBloc>().add(const ChangeWiFiMode(ESP32WiFiMode.client)),
              );
            }

            final isApMode = state.wifiMode == ESP32WiFiMode.ap;

            final header = _ConnectionModeHeader(
              wifiMode: state.wifiMode,
              onModeChanged: (mode) {
                context.read<MowerConnectionBloc>().add(ChangeWiFiMode(mode));
              },
              onOpenWifiSettings: isApMode ? () => PlatformSettings.openWifiSettings() : null,
              onRetryScan: Platform.isAndroid
                  ? () => context.read<MowerConnectionBloc>().add(const AutoDetectWifiMode(ssidPrefix: 'mower'))
                  : null,
              scanStatus: state.wifiScanStatus,
            );

            if (isApMode) {
              // AP mode: no form; only guide user to pick the mower Wi‑Fi network.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  header,
                  const SizedBox(height: 24),
                  const Text(
                    'Mower network detected (AP mode).\n\n1) Open Wi‑Fi settings\n2) Connect to the mower network\n3) Come back and tap Connect',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => PlatformSettings.openWifiSettings(),
                    icon: const Icon(Icons.wifi),
                    label: const Text('Open Wi‑Fi Settings'),
                  ),
                  const SizedBox(height: 16),
                  ConnectionButton(formKey: _formKey),
                ],
              );
            }

            // Client/standalone mode: keep existing UI, just add the header.
            return screenOrientation == Orientation.portrait
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      header,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ConnectionForm(formKey: _formKey),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ConnectionButton(formKey: _formKey),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            header,
                            const SizedBox(height: 12),
                            Expanded(child: ConnectionForm(formKey: _formKey)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(flex: 1, child: ConnectionButton(formKey: _formKey)),
                      const Flexible(child: SizedBox(width: 20)),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _WifiScanLoading extends StatelessWidget {
  final VoidCallback onOpenWifiSettings;

  const _WifiScanLoading({required this.onOpenWifiSettings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Scanning Wi‑Fi for mower network (up to 30s)...'),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onOpenWifiSettings,
            icon: const Icon(Icons.wifi),
            label: const Text('Open Wi‑Fi Settings'),
          ),
        ],
      ),
    );
  }
}

class _WifiScanFailed extends StatelessWidget {
  final String message;
  final VoidCallback? onOpenLocationSettings;
  final VoidCallback onOpenWifiSettings;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  const _WifiScanFailed({
    required this.message,
    required this.onOpenLocationSettings,
    required this.onOpenWifiSettings,
    required this.onRetry,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Can\'t scan Wi‑Fi networks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(message),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (onOpenLocationSettings != null)
                      FilledButton.icon(
                        onPressed: onOpenLocationSettings,
                        icon: const Icon(Icons.location_on),
                        label: const Text('Turn on Location'),
                      ),
                    OutlinedButton.icon(
                      onPressed: onOpenWifiSettings,
                      icon: const Icon(Icons.wifi),
                      label: const Text('Open Wi‑Fi'),
                    ),
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onContinue,
                  child: const Text('Continue without scan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionModeHeader extends StatelessWidget {
  final ESP32WiFiMode wifiMode;
  final ValueChanged<ESP32WiFiMode> onModeChanged;
  final VoidCallback? onOpenWifiSettings;
  final VoidCallback? onRetryScan;
  final WifiScanStatus scanStatus;

  const _ConnectionModeHeader({
    required this.wifiMode,
    required this.onModeChanged,
    required this.onOpenWifiSettings,
    required this.onRetryScan,
    required this.scanStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<ESP32WiFiMode>(
            segments: const [
              ButtonSegment(
                value: ESP32WiFiMode.client,
                label: Text('Client'),
                icon: Icon(Icons.router),
              ),
              ButtonSegment(
                value: ESP32WiFiMode.ap,
                label: Text('AP'),
                icon: Icon(Icons.wifi_tethering),
              ),
            ],
            selected: {wifiMode},
            onSelectionChanged: (selection) {
              if (selection.isEmpty) return;
              onModeChanged(selection.first);
            },
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          tooltip: 'Retry AP detection',
          onPressed: onRetryScan,
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          tooltip: 'Open Wi‑Fi settings',
          onPressed: onOpenWifiSettings,
          icon: const Icon(Icons.settings),
        ),
      ],
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