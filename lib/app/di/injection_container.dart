import 'package:get_it/get_it.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/data/network/websocket_config.dart';
import 'package:mower_bot/features/connection/data/repository/connection_repository_impl.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_ctrl_ws_connected_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/stream_connection_status_use_case.dart';
import 'package:mower_bot/features/control/data/repository/control_repository_impl.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/camera_cubit.dart';
import 'package:mower_bot/features/control/presentation/bloc/recording_cubit.dart';
import 'package:mower_bot/features/paths/data/repository/path_repository_remote_impl.dart';
import 'package:mower_bot/features/paths/domain/repository/path_repository.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/save_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/stop_path.dart';
import 'package:mower_bot/features/telemetry/data/repository/telemetry_repository_impl.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/stop_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';
import 'package:mower_bot/core/platform/mower_reachability_service.dart';
import 'package:mower_bot/core/platform/wifi_join_service.dart';
import 'package:mower_bot/core/platform/wifi_scan_permission_service.dart';
import 'package:mower_bot/core/platform/wifi_scanner.dart';
import 'package:mower_bot/core/platform/permission_rationale_store.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _registerCore();
  _registerConnection();
  _registerPaths();
  _registerControl();
  _registerTelemetry();
  _registerBlocs();
}

void _registerCore() {
  // Core primitives & adapters
  sl.registerLazySingleton<WebSocketConfig>(() => WebSocketConfig());
  sl.registerLazySingleton<ControlWebSocketClient>(
    () => ControlWebSocketClient(config: sl<WebSocketConfig>()),
    dispose: (client) => client.dispose(),
  );
  sl.registerLazySingleton<BinaryWebSocketClient>(
    () => BinaryWebSocketClient(config: sl<WebSocketConfig>()),
    dispose: (client) => client.dispose(),
  );

  // Named interface registrations (remove unnamed duplicate for clarity)
  sl.registerLazySingleton<IWebSocketClient>(
    () => sl<ControlWebSocketClient>(),
    instanceName: 'ctrl',
  );
  sl.registerLazySingleton<IWebSocketClient>(
    () => sl<BinaryWebSocketClient>(),
    instanceName: 'binary',
  );
}

void _registerConnection() {
  sl.registerLazySingleton<MowerConnectionRepository>(
    () => MowerConnectionRepositoryImpl(
      sl<IWebSocketClient>(instanceName: 'ctrl'),
    ),
    dispose: (repository) => repository.dispose(),
  );
  sl.registerLazySingleton<ConnectToCtrlWsUseCase>(
    () => ConnectToCtrlWsUseCase(sl()),
  );
  sl.registerLazySingleton<DisconnectCtrlWsUseCase>(
    () => DisconnectCtrlWsUseCase(sl()),
  );
  sl.registerLazySingleton<CheckCtrlWsConnectedUseCase>(
    () => CheckCtrlWsConnectedUseCase(sl()),
  );
  sl.registerLazySingleton<StreamConnectionStatusUseCase>(
    () => StreamConnectionStatusUseCase(sl()),
  );
  sl.registerLazySingleton<WifiScanPermissionService>(
    () => WifiScanPermissionService(),
  );
  sl.registerLazySingleton<WifiScanner>(() => WifiScanner());
  sl.registerLazySingleton<PermissionRationaleStore>(
    () => PermissionRationaleStore(),
  );
  sl.registerLazySingleton<WifiJoinService>(() => WifiJoinService());
  sl.registerLazySingleton<MowerReachabilityService>(
    () => MowerReachabilityService(),
  );
}

void _registerPaths() {
  sl.registerLazySingleton<PathRepository>(
    () => PathRepositoryRemote(sl<IWebSocketClient>(instanceName: 'ctrl')),
    dispose: (repository) => repository.dispose(),
  );
  sl.registerLazySingleton<GetPathsUseCase>(() => GetPathsUseCase(sl()));
  sl.registerLazySingleton<PlayPathUseCase>(() => PlayPathUseCase(sl()));
  sl.registerLazySingleton<StopPathUseCase>(() => StopPathUseCase(sl()));
  sl.registerLazySingleton<DeletePathUseCase>(() => DeletePathUseCase(sl()));
  sl.registerLazySingleton<SavePathUseCase>(() => SavePathUseCase(sl()));
}

void _registerControl() {
  sl.registerLazySingleton<ControlRepository>(
    () => ControlRepositoryImpl(
      controlWebSocketClient: sl<IWebSocketClient>(instanceName: 'ctrl'),
      binaryWebSocketClient: sl<IWebSocketClient>(instanceName: 'binary'),
    ),
  );
  sl.registerLazySingleton<GetVideoStreamUrlUseCase>(
    () => GetVideoStreamUrlUseCase(sl()),
  );
  sl.registerLazySingleton<SendDriveCommandUseCase>(
    () => SendDriveCommandUseCase(sl()),
  );
}

void _registerTelemetry() {
  sl.registerLazySingleton<TelemetryRepository>(
    () => TelemetryRepositoryImpl(sl<IWebSocketClient>(instanceName: 'ctrl')),
    dispose: (repository) => repository.dispose(),
  );
  sl.registerLazySingleton<ObserverTelemetryUseCase>(
    () => ObserverTelemetryUseCase(sl()),
  );
  sl.registerLazySingleton<ObserverTelemetryStatusUseCase>(
    () => ObserverTelemetryStatusUseCase(sl()),
  );
  sl.registerLazySingleton<StartTelemetryStreamUseCase>(
    () => StartTelemetryStreamUseCase(sl()),
  );
  sl.registerLazySingleton<StopTelemetryStreamUseCase>(
    () => StopTelemetryStreamUseCase(sl()),
  );
}

void _registerBlocs() {
  // Blocs: choose lifecycle (singleton vs factory). TelemetryBloc is a singleton so others share its stream.
  sl.registerLazySingleton<TelemetryBloc>(
    () => TelemetryBloc(
      sl<StartTelemetryStreamUseCase>(),
      sl<StopTelemetryStreamUseCase>(),
      sl<ObserverTelemetryUseCase>(),
      sl<ObserverTelemetryStatusUseCase>(),
    ),
    dispose: (bloc) => bloc.close(),
  );

  // Factories provide fresh instances if needed (currently created once at app start).
  sl.registerFactory<MowerConnectionBloc>(
    () => MowerConnectionBloc(
      sl<ConnectToCtrlWsUseCase>(),
      sl<DisconnectCtrlWsUseCase>(),
      sl<CheckCtrlWsConnectedUseCase>(),
      sl<MowerConnectionRepository>(),
      sl<WifiScanner>(),
      sl<WifiScanPermissionService>(),
      sl<WifiJoinService>(),
      sl<MowerReachabilityService>(),
    ),
  );

  sl.registerFactory<ControlBloc>(
    () => ControlBloc(
      sl<SendDriveCommandUseCase>(),
      sl<ObserverTelemetryUseCase>(),
    ),
  );
  sl.registerFactory<CameraCubit>(
    () => CameraCubit(sl<GetVideoStreamUrlUseCase>()),
  );
  sl.registerFactory<RecordingCubit>(
    () => RecordingCubit(sl<SavePathUseCase>()),
  );

  sl.registerFactory<PathBloc>(
    () => PathBloc(
      sl<GetPathsUseCase>(),
      sl<PlayPathUseCase>(),
      sl<StopPathUseCase>(),
      sl<DeletePathUseCase>(),
    ),
  );
}
