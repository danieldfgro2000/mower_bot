import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class ConnectionStatusTile extends StatelessWidget {
  const ConnectionStatusTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      MowerConnectionBloc,
      MowerConnectionState,
      ConnectionStatus
    >(
      selector: (s) => s.status,
      builder: (context, status) {
        final color = switch (status) {
          ConnectionStatus.ctrlWsConnected => Colors.green,
          ConnectionStatus.videoWsConnected => Colors.blue,
          ConnectionStatus.connecting => Colors.orange,
          ConnectionStatus.disconnected => Colors.red,
          ConnectionStatus.hostUnreachable => Colors.redAccent,
          ConnectionStatus.error => Colors.redAccent,
        };
        return ListTile(
          title: const Text('Status'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == ConnectionStatus.connecting)
                const CircularProgressIndicator(
                  constraints: BoxConstraints(maxHeight: 24, maxWidth: 24),
                ),
              const SizedBox(width: 8),
              Text(
                status.name.toUpperCase(),
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
