import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class ConnectionPage extends StatefulWidget {
  static const String routeName = '/connection';

  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final ipController = TextEditingController(text: '172.20.10.12');
  final portController = TextEditingController(text: '81');

  @override
  Widget build(BuildContext context) {
    context.read<MowerConnectionBloc>().add(CheckConnectionStatus());
    final connectionStatus = context.watch<MowerConnectionBloc>().state.status;

    return Scaffold(
      appBar: AppBar(title: const Text('Connection'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  title: const Text('Status'),
                  trailing: Text(
                    state.status.name.toUpperCase(),
                    style: TextStyle(
                      color: state.status == ConnectionStatus.connected
                          ? Colors.green
                          : state.status == ConnectionStatus.error
                          ? Colors.red
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ipController,
                  decoration: const InputDecoration(
                    labelText: 'Mower IP Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: portController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    final ip = ipController.text.trim();
                    final port = int.tryParse(portController.text) ?? 81;
                    connectionStatus == ConnectionStatus.connected
                        ? context.read<MowerConnectionBloc>().add(DisconnectFromMower())
                        : context.read<MowerConnectionBloc>().add(ConnectToMower(ip, port));
                  },
                  icon: Icon(
                    connectionStatus == ConnectionStatus.connected
                        ? Icons.wifi
                        : Icons.wifi_off,
                  ),
                  label: Text(
                      connectionStatus == ConnectionStatus.connected
                          ? 'Disconnect'
                          : 'Connect'
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
