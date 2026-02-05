import 'package:flutter/material.dart';

Future<bool> isLocationPermissionAccepted(BuildContext context) async =>
   await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Location permission needed'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Android requires Location permission to scan nearby Wi‑Fi network names (SSIDs).\n\n'
                    'We only use this to detect the MowerBot-AP Wi‑Fi network automatically.\n'
                    'If you choose to deny the Location permission, you will have to connect manually to the MowerBot-AP network.\n\n'
                    'We do not track or store your location.',
              ),
            ],
          ),
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
  ) ?? false;

