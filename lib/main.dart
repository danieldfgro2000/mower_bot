import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/network/websocket_client.dart';

import 'features/control/presentation/pages/control_page.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';

void main() {
  final client = WebSocketClient();
  client.connectDummy();

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final WebSocketClient client;
  const MyApp({super.key, required this.client});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mower Bot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: BlocProvider(
        create: (context) => TelemetryBloc(client.messages),
        child: const ControlPage(),
      ),
    );
  }
}