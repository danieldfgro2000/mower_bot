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
  String ip = '172.20.10.12';
  int port = 81;

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
      buildWhen: (p, n) => p.status != n.status || p.ip != n.ip || p.port != n.port,
      builder: (context, state) {
        isBusy = state.status == ConnectionStatus.connecting;
        isConnected = state.status == ConnectionStatus.connected;
        return ElevatedButton.icon(
          onPressed: isBusy
            ? null
            :_handleOnPressed,
          icon: Icon(isConnected ? Icons.wifi : Icons.wifi_off),
          label: Text(isConnected ? 'Disconnect' : 'Connect'),
        );
      });
  }

  void _handleOnPressed() {
    if(!widget.formKey.currentState!.validate()) return;

    final event = context.read<MowerConnectionBloc>().add;
    isConnected
      ? event(DisconnectFromMower())
      : event(ConnectToMower());
  }
}
