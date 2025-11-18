import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

import 'components/connection_button.dart';
import 'components/connection_form.dart';

class ConnectionPage extends StatefulWidget {
  static const String routeName = '/connection';

  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<MowerConnectionBloc>().add(CheckConnectionStatus());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenOrientation = MediaQuery.of(context).orientation;
    return  MultiBlocListener(
      listeners: [
        BlocListener<MowerConnectionBloc, MowerConnectionState>(
          listenWhen: (p, c) => p.error  != c.error,
          listener: (context, state) {
            String? err = state.error;
            if (err == null || err.isEmpty) return;
            _showSnackBar(context, state.error!, isError: true);
          },
        )
      ],
      child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 20),
          maintainBottomViewPadding: true,
          child: screenOrientation == Orientation.portrait
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConnectionForm(formKey: _formKey),
              SizedBox(height: screenHeight / 4),
              ConnectionButton(formKey: _formKey),
            ],
          )
              : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: ConnectionForm(formKey: _formKey)),
                Flexible(child: SizedBox(width: 20)),
                Flexible(flex: 1, child: ConnectionButton(formKey: _formKey)),
                Flexible(child: SizedBox(width: 20)),
              ]
          )
      ),
    );
  }
}

void _showSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red : null,
      duration: const Duration(seconds: 2),
    ),
  );
}