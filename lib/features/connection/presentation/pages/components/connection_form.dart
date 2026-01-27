import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
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
  static const _clientDefaultIp = '192.168.100.114';
  static const _apDefaultIp = '192.168.4.1';

  late final TextEditingController ipController;
  late final TextEditingController portController;
  late final TextEditingController apSsidController;
  late final TextEditingController apPasswordController;

  bool _showApPassword = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MowerConnectionBloc>();
    final s = bloc.state;

    final defaultIp = s.wifiMode == ESP32WiFiMode.ap ? _apDefaultIp : _clientDefaultIp;

    ipController = TextEditingController(text: s.ip ?? defaultIp);
    portController = TextEditingController(text: (s.port?.toString() ?? '85'));

    apSsidController = TextEditingController(text: s.apSsid);
    apPasswordController = TextEditingController(text: s.apPassword);

    bloc.add(ChangeIp(ipController.text));
    final initialPort = int.tryParse(portController.text);
    if (initialPort != null) bloc.add(ChangePort(initialPort));

    // Ensure defaults are present in bloc state (so auto-join can use them).
    bloc.add(ChangeApSsid(apSsidController.text));
    bloc.add(ChangeApPassword(apPasswordController.text));
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    apSsidController.dispose();
    apPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MowerConnectionBloc>();
    final isBusy = context.select(
      (MowerConnectionBloc bloc) => bloc.state.connectionStatus == ConnectionStatus.connecting,
    );

    final wifiMode = context.select((MowerConnectionBloc b) => b.state.wifiMode);

    return BlocListener<MowerConnectionBloc, MowerConnectionState>(
      listenWhen: (p, n) => p.wifiMode != n.wifiMode,
      listener: (context, state) {
        // Swap IP defaults when switching modes (only if user didn't customize it).
        final currentText = ipController.text.trim();
        final nextDefault = state.wifiMode == ESP32WiFiMode.ap ? _apDefaultIp : _clientDefaultIp;
        final otherDefault = state.wifiMode == ESP32WiFiMode.ap ? _clientDefaultIp : _apDefaultIp;

        if (currentText.isEmpty || currentText == otherDefault || currentText == _clientDefaultIp || currentText == _apDefaultIp) {
          ipController.text = nextDefault;
          bloc.add(ChangeIp(nextDefault));
        }
      },
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // AP mode: user configures mower SSID/password (Android will try to auto-join).
            if (wifiMode == ESP32WiFiMode.ap) ...[
              TextFormField(
                controller: apSsidController,
                decoration: const InputDecoration(
                  labelText: 'Mower Wi‑Fi SSID',
                  border: OutlineInputBorder(),
                ),
                enabled: !isBusy,
                onChanged: (v) => bloc.add(ChangeApSsid(v)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: apPasswordController,
                decoration: InputDecoration(
                  labelText: 'Mower Wi‑Fi Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: _showApPassword ? 'Hide password' : 'Show password',
                    onPressed: isBusy
                        ? null
                        : () {
                            setState(() {
                              _showApPassword = !_showApPassword;
                            });
                          },
                    icon: Icon(
                      _showApPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                enabled: !isBusy,
                obscureText: !_showApPassword,
                onChanged: (v) => bloc.add(ChangeApPassword(v)),
              ),
              const SizedBox(height: 16),
            ],

            // IP/Port are only meaningful in Client mode (AP mode uses the standard 192.168.4.1:85).
            if (wifiMode == ESP32WiFiMode.client) ...[
              TextFormField(
                controller: ipController,
                decoration: const InputDecoration(
                  labelText: 'Mower IP Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
          ],
        ),
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

String? _validatePort(String? v) {
  final s = (v ?? '').trim();
  if (s.isEmpty) return 'Port cannot be empty';
  final p = int.tryParse(s);
  if (p == null) return 'Port must be numeric';
  if (p < 1 || p > 65535) return 'Port must be 1-65535';
  return null;
}
