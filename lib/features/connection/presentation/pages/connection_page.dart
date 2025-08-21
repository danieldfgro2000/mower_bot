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
                      fontWeight: FontWeight.bold
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
                if(state.status == ConnectionStatus.disconnected)
                  ElevatedButton.icon(
                    onPressed: (){
                      final ip = ipController.text.trim();
                      final port = int.tryParse(portController.text) ?? 81;
                      context.read<MowerConnectionBloc>().add(
                        ConnectToMower(ip, port),
                      );
                    },
                    icon: const Icon(Icons.wifi),
                    label: const Text('Connect'),
                  ),
                if(state.status == ConnectionStatus.connected)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MowerConnectionBloc>().add(DisconnectFromMower());
                    },
                    icon: const Icon(Icons.wifi_off),
                    label: const Text('Disconnect'),
                  ),
                if(state.status == ConnectionStatus.connecting)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
