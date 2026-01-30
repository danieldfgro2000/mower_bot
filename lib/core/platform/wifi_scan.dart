import 'package:flutter/material.dart';

class WifiScanLoading extends StatelessWidget {
  final VoidCallback onOpenWifiSettings;

  const WifiScanLoading({super.key, required this.onOpenWifiSettings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Scanning Wi‑Fi for MowerBot network (up to 30s)...'),
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

class WifiScanFailed extends StatelessWidget {
  final String message;
  final VoidCallback? onOpenLocationSettings;
  final VoidCallback onOpenWifiSettings;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  const WifiScanFailed({
    super.key,
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