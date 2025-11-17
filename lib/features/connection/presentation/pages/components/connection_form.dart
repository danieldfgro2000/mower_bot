import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class ConnectionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ConnectionForm({super.key, required this.formKey});

  @override
  State<ConnectionForm> createState() => _ConnectionFormState();
}

class _ConnectionFormState extends State<ConnectionForm> {
  late final TextEditingController ipController;
  late final TextEditingController portController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MowerConnectionBloc>();
    final s = bloc.state;
    ipController = TextEditingController(text: s.ip ?? '192.168.100.114');
    bloc.add(ChangeIp(ipController.text));
  }

  @override
  void dispose() {
    super.dispose();
    ipController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MowerConnectionBloc>();
    final isBusy = context.select(
      (MowerConnectionBloc bloc) =>
          bloc.state.status == ConnectionStatus.connecting,
    );
    return Form(
      key: widget.formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: ipController,
                    decoration: const InputDecoration(
                      labelText: 'Mower IP Address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                    validator: _validateIp,
                    autofillHints: const [AutofillHints.url],
                    enabled: !isBusy,
                    onChanged: (ip) => bloc.add(ChangeIp(ip)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: portController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Port',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validatePort,
                    enabled: !isBusy,
                    onChanged: (port) {
                      final p = int.tryParse(port);
                      if (p != null) bloc.add(ChangePort(p));
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String? _validateIp(String? v) {
  final s = (v ?? '').trim();
  if (s.isEmpty) {
    return 'IP Address cannot be empty';
  }
  final ipv4 = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
  if (!ipv4.hasMatch(s)) return 'Invalid IP Address format';
  return null;
}