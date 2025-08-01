import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/data/repositories/connection_repository_impl.dart';
import 'package:mower_bot/features/paths/data/repositories/path_repository_impl.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';
import 'package:mower_bot/features/telemetry/data/datasources/telemetry_remote_datasource.dart';
import 'package:mower_bot/features/telemetry/data/repositories/telemetry_repository_impl.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/get_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';

import 'core/di/injection_container.dart';
import 'features/connection/domain/usecases/check_mower_status.dart';
import 'features/connection/domain/usecases/connect_to_mower.dart';
import 'features/connection/domain/usecases/disconnect_mower.dart';
import 'features/connection/presentation/bloc/connection_bloc.dart';
import 'features/control/presentation/bloc/control_bloc.dart';
import 'features/paths/domain/usecases/stop_path.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider<MowerConnectionBloc>(
          create: (context) => MowerConnectionBloc(
            sl(), // ConnectToMowerUseCase
            sl(), // DisconnectMowerUseCase
            sl(), // CheckMowerStatusUseCase
            sl<MowerConnectionRepositoryImpl>().connectionChanges(),
            onConnected: (url) {
              context.read<TelemetryBloc>().add(StartTelemetry(wsUrl: url));
            },
          ),
        ),
        BlocProvider<TelemetryBloc>(create: (context) => TelemetryBloc(sl())),
        BlocProvider(create: (context) =>
            ControlBloc((cmd) => sl<WebSocketClient>().send(cmd))),
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
