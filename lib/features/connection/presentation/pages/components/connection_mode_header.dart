import 'package:flutter/material.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

typedef InfoBuilder = Widget Function(BuildContext context);

enum _HeaderMenuAction { retryScan, openWifiSettings }

class ConnectionModeHeader extends StatelessWidget {
  final ESP32WiFiMode wifiMode;
  final ValueChanged<ESP32WiFiMode> onModeChanged;
  final VoidCallback? onOpenWifiSettings;
  final VoidCallback? onRetryScan;
  final WifiScanStatus scanStatus;
  final InfoBuilder? infoBuilder;

  const ConnectionModeHeader({
    super.key,
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
