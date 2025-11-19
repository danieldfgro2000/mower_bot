import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';
import 'package:mower_bot/mower_bloc_observer.dart';
import 'core/di/injection_container.dart';
import 'features/connection/presentation/bloc/connection_bloc.dart';
import 'features/control/presentation/bloc/control_bloc.dart';
import 'features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'home_page.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MowerBlocObserver();
  await initDependencies();
  runApp(const MowerApp());
}

void main() => bootstrap();

class MowerApp extends StatelessWidget {
  const MowerApp({super.key});

  @override
  Widget build(BuildContext context) =>
    AppProviders(
      child: MaterialApp(
        title: 'Mower App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)
        ),
        home: const HomePage(),
      ),
    );
}

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // TelemetryBloc is a singleton; use value to prevent Provider disposing it
        BlocProvider<TelemetryBloc>.value(value: sl<TelemetryBloc>()),
        BlocProvider<MowerConnectionBloc>(create: (_) => sl<MowerConnectionBloc>()),
        BlocProvider<ControlBloc>(create: (_) => sl<ControlBloc>()),
        BlocProvider<PathBloc>(create: (_) => sl<PathBloc>()),
      ],
      child: child,
    );
  }
}
