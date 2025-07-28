import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/features/connection/data/repositories/connection_repository_impl.dart';
import 'package:mower_bot/features/paths/data/repositories/path_repository_impl.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';

import 'features/connection/domain/usecases/check_mower_status.dart';
import 'features/connection/domain/usecases/connect_to_mower.dart';
import 'features/connection/domain/usecases/disconnect_mower.dart';
import 'features/connection/presentation/bloc/connection_bloc.dart';
import 'features/control/presentation/bloc/control_bloc.dart';
import 'features/paths/domain/usecases/stop_path.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'home_page.dart';

void main() {
  final client = WebSocketClient();
  client.connectDummy();

  final connectionRepository = MowerConnectionRepositoryImpl();
  final pathRepository = MockPathRepository();

  runApp(
    MyApp(
      client: client,
      connectionRepository: connectionRepository,
      pathRepository: pathRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final MowerConnectionRepositoryImpl connectionRepository;
  final MockPathRepository pathRepository;
  final WebSocketClient client;

  const MyApp({
    super.key,
    required this.client,
    required this.connectionRepository,
    required this.pathRepository,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MowerConnectionBloc>(
          create: (context) => MowerConnectionBloc(
            ConnectToMowerUseCase(connectionRepository),
            DisconnectMowerUseCase(connectionRepository),
            CheckMowerStatusUseCase(connectionRepository),
            connectionRepository.connectionChanges()
          ),
        ),
        BlocProvider<TelemetryBloc>(
          create: (context) => TelemetryBloc(client.messages),
        ),
        BlocProvider(
          create: (context) => ControlBloc((cmd) => client.send(cmd)),
        ),
        BlocProvider(
          create: (_) => PathBloc(
            GetPathsUseCase(pathRepository),
            PlayPathUseCase(pathRepository),
            StopPathUseCase(pathRepository),
            DeletePathUseCase(pathRepository),
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
