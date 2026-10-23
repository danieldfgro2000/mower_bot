import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/app/device_session_coordinator.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';
import 'package:mower_bot/mower_bloc_observer.dart';
import 'app/di/injection_container.dart';
import 'app/router/app_router.dart';
import 'features/connection/presentation/bloc/connection_bloc.dart';
import 'features/connection/presentation/bloc/connection_state.dart';
import 'features/control/presentation/bloc/camera_cubit.dart';
import 'features/control/presentation/bloc/control_bloc.dart';
import 'features/control/presentation/bloc/recording_cubit.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'features/telemetry/presentation/bloc/telemetry_event.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MowerBlocObserver();
  await initDependencies();
  runApp(const MowerApp());
}

void main() => bootstrap();

class MowerApp extends StatefulWidget {
  const MowerApp({super.key});

  @override
  State<MowerApp> createState() => _MowerAppState();
}

class _MowerAppState extends State<MowerApp> {
  late final _router = AppRouter.create();
  late final DeviceSessionCoordinator _deviceSessionCoordinator;

  @override
  void initState() {
    super.initState();
    final telemetryBloc = sl<TelemetryBloc>();
    _deviceSessionCoordinator = DeviceSessionCoordinator(
      startTelemetry: () => telemetryBloc.add(StartTelemetry()),
      stopTelemetry: () => telemetryBloc.add(StopTelemetry()),
    );
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<TelemetryBloc>.value(value: sl<TelemetryBloc>()),
      BlocProvider<MowerConnectionBloc>(
        create: (_) => sl<MowerConnectionBloc>(),
      ),
      BlocProvider<CameraCubit>(create: (_) => sl<CameraCubit>()),
      BlocProvider<ControlBloc>(create: (_) => sl<ControlBloc>()),
      BlocProvider<RecordingCubit>(create: (_) => sl<RecordingCubit>()),
      BlocProvider<PathBloc>(create: (_) => sl<PathBloc>()),
    ],
    child: BlocListener<MowerConnectionBloc, MowerConnectionState>(
      listenWhen: (previous, current) =>
          previous.connectionStatus != current.connectionStatus,
      listener: (context, state) {
        _deviceSessionCoordinator.synchronize(state.connectionStatus);
        context.read<CameraCubit>().refresh();
      },
      child: MaterialApp.router(
        title: 'Mower App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        routerConfig: _router,
      ),
    ),
  );
}
