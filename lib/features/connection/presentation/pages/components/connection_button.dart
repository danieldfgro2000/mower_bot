import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class ConnectionButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const ConnectionButton({super.key, required this.formKey});

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton> {
  bool isBusy = false;
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
      buildWhen: (p, n) => p.connectionStatus != n.connectionStatus || p.ip != n.ip || p.port != n.port,
      builder: (context, state) {
        isBusy = state.connectionStatus == ConnectionStatus.connecting;
        isConnected = state.connectionStatus == ConnectionStatus.ctrlWsConnected;

        final icon = isConnected ? Icons.cloud_off : Icons.cloud_queue;
        final label = isConnected ? 'Disconnect WebSocket' : 'Connect WebSocket';

        return FilledButton.icon(
          onPressed: isBusy ? null : _handleOnPressed,
          icon: Icon(icon),
          label: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  void _handleOnPressed() {
    // In AP mode we intentionally don't render the form, so the key won't have a currentState.
    // Only validate if a form is currently mounted.
    final formState = widget.formKey.currentState;
    if (formState != null && !formState.validate()) return;

    final event = context.read<MowerConnectionBloc>().add;
    isConnected ? event(DisconnectFromMower()) : event(ConnectToMower());
  }
}
