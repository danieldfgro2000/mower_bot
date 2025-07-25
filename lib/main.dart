import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/network/websocket_client.dart';

import 'features/control/presentation/bloc/control_bloc.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'home_page.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<TelemetryBloc>(
          create: (context) => TelemetryBloc(client.messages),
        ),
        BlocProvider(
          create: (context) => ControlBloc((cmd) => client.send(cmd)),
        ),
      ],
      child: MaterialApp(
        title: 'Mower App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: HomePage(),
      ),
    );
  }
}
