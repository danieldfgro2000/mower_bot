import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';
import 'package:mower_bot/mower_bloc_observer.dart';

import 'core/di/injection_container.dart';
import 'features/connection/presentation/bloc/connection_bloc.dart';
import 'features/control/presentation/bloc/control_bloc.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MowerBlocObserver();
  await initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TelemetryBloc>(
          create: (context) => TelemetryBloc(sl(), sl(), sl()),
        ),
        BlocProvider<MowerConnectionBloc>(
          create: (context) => MowerConnectionBloc(
            sl(), // ConnectToMowerUseCase
            sl(), // DisconnectMowerUseCase
            sl(), // CheckMowerStatusUseCase
            context.read<TelemetryBloc>(), // TelemetryBloc
            sl(),
          ),
        ),
        BlocProvider(create: (context) =>
            ControlBloc((cmd) => sl<ControlWebSocketClient>().send(cmd), sl(), sl(), sl())),
        BlocProvider(
          create: (_) => PathBloc(
            sl(), // GetPathsUseCase
            sl(), // PlayPathUseCase
            sl(), // StopPathUseCase
            sl(), // DeletePathUseCase
          ),
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
