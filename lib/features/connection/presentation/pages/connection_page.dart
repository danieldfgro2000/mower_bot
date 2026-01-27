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

  bool _permissionDialogOpen = false;

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
        ),
        BlocListener<MowerConnectionBloc, MowerConnectionState>(
          listenWhen: (p, c) => p.wifiScanStatus != c.wifiScanStatus,
          listener: (context, state) async {
            if (!Platform.isAndroid) return;
            if (state.wifiScanStatus != WifiScanStatus.needsPermission) return;
            if (_permissionDialogOpen) return;

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

            _permissionDialogOpen = false;

            if (!context.mounted) return;
            if (accepted == true) {
              context.read<MowerConnectionBloc>().add(const WifiScanPermissionInfoAccepted());
            } else {
              context.read<MowerConnectionBloc>().add(const WifiScanPermissionInfoDeclined());
            }
          },
        ),
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
              infoBuilder: isApMode
                  ? (ctx) => const Text(
                        'Some Android versions still require a manual confirm in Wi‑Fi settings.\n\n'
                        '1) (Optional) Open Wi‑Fi settings and connect to the mower network\n'
                        '2) Come back and tap “Connect WebSocket”\n\n'
                        'Tip: the default SSID is usually MowerBot-AP and the default password is mowerbot123.',
                      )
                  : null,
            );

            if (isApMode) {
              // AP mode: guide user and allow editing AP credentials + IP/port.
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    header,
                    const SizedBox(height: 12),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ConnectionForm(formKey: _formKey),
                    ),
                    const SizedBox(height: 16),
                    ConnectionButton(formKey: _formKey),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }

            // Client/standalone mode: keep existing UI, just add the header.
            return screenOrientation == Orientation.portrait
                ? SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        header,
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ConnectionForm(formKey: _formKey),
                        ),
                        const SizedBox(height: 16),
                        ConnectionButton(formKey: _formKey),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              header,
                              const SizedBox(height: 12),
                              ConnectionForm(formKey: _formKey),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 0),
                              ConnectionButton(formKey: _formKey),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
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

typedef _InfoBuilder = Widget Function(BuildContext context);

enum _HeaderMenuAction {
  retryScan,
  openWifiSettings,
}

class _ConnectionModeHeader extends StatelessWidget {
  final ESP32WiFiMode wifiMode;
  final ValueChanged<ESP32WiFiMode> onModeChanged;
  final VoidCallback? onOpenWifiSettings;
  final VoidCallback? onRetryScan;
  final WifiScanStatus scanStatus;
  final _InfoBuilder? infoBuilder;

  const _ConnectionModeHeader({
    required this.wifiMode,
    required this.onModeChanged,
    required this.onOpenWifiSettings,
    required this.onRetryScan,
    required this.scanStatus,
    this.infoBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final hasMenu = (onRetryScan != null) || (onOpenWifiSettings != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
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
            const SizedBox(width: 8),
            if (infoBuilder != null)
              IconButton(
                constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                tooltip: 'Info',
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Info'),
                        content: SingleChildScrollView(child: infoBuilder!(ctx)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.info_outline),
              ),
            if (hasMenu)
              PopupMenuButton<_HeaderMenuAction>(
                tooltip: 'More',
                icon: const Icon(Icons.more_vert),
                itemBuilder: (ctx) => <PopupMenuEntry<_HeaderMenuAction>>[
                  if (onRetryScan != null)
                    const PopupMenuItem<_HeaderMenuAction>(
                      value: _HeaderMenuAction.retryScan,
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.refresh),
                        title: Text('Retry scan'),
                      ),
                    ),
                  if (onOpenWifiSettings != null)
                    const PopupMenuItem<_HeaderMenuAction>(
                      value: _HeaderMenuAction.openWifiSettings,
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.wifi),
                        title: Text('Wi‑Fi settings'),
                      ),
                    ),
                ],
                onSelected: (action) {
                  switch (action) {
                    case _HeaderMenuAction.retryScan:
                      onRetryScan?.call();
                      break;
                    case _HeaderMenuAction.openWifiSettings:
                      onOpenWifiSettings?.call();
                      break;
                  }
                },
              ),
          ],
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
