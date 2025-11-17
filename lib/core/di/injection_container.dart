import 'package:get_it/get_it.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/data/network/websocket_config.dart';
import 'package:mower_bot/core/data/repo/connection_repository_impl.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_ctrl_ws_connected_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_ctrl_ws_use_case.dart';
import 'package:mower_bot/core/data/repo/control_repository_impl.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/core/data/repo/path_repository_impl.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/stop_path.dart';
import 'package:mower_bot/core/data/repo/telemetry_repository_impl.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// Core
  sl.registerLazySingleton<WebSocketConfig>(() => WebSocketConfig());
  sl.registerLazySingleton<ControlWebSocketClient>(() => ControlWebSocketClient());
  sl.registerLazySingleton<BinaryWebSocketClient>(() => BinaryWebSocketClient());
  sl.registerLazySingleton<IWebSocketClient>(() => sl<ControlWebSocketClient>());
  sl.registerLazySingleton<IWebSocketClient>(() => sl<ControlWebSocketClient>(), instanceName: 'ctrl');
  sl.registerLazySingleton<IWebSocketClient>(() => sl<BinaryWebSocketClient>(), instanceName: 'binary');

  /// Connection
  sl.registerLazySingleton<MowerConnectionRepository>(() => MowerConnectionRepositoryImpl());
  sl.registerLazySingleton<ConnectToCtrlWsUseCase>(() => ConnectToCtrlWsUseCase(sl()));
  sl.registerLazySingleton<DisconnectCtrlWsUseCase>(() => DisconnectCtrlWsUseCase(sl()));
  sl.registerLazySingleton<CheckCtrlWsConnectedUseCase>(() => CheckCtrlWsConnectedUseCase(sl()));

  /// Paths
  sl.registerLazySingleton<PathRepository>(() => MockPathRepository());
  sl.registerLazySingleton<GetPathsUseCase>(() => GetPathsUseCase(sl()));
  sl.registerLazySingleton<PlayPathUseCase>(() => PlayPathUseCase(sl()));
  sl.registerLazySingleton<StopPathUseCase>(() => StopPathUseCase(sl()));
  sl.registerLazySingleton<DeletePathUseCase>(() => DeletePathUseCase(sl()));

  /// Control
  sl.registerLazySingleton<ControlRepository>(() => ControlRepositoryImpl(
    controlWebSocketClient: sl<IWebSocketClient>(instanceName: 'ctrl'),
    binaryWebSocketClient: sl<IWebSocketClient>(instanceName: 'binary'),
  ));
  sl.registerLazySingleton<GetVideoStreamUrlUseCase>(() => GetVideoStreamUrlUseCase(sl()));
  sl.registerLazySingleton<SendDriveCommandUseCase>(() => SendDriveCommandUseCase(sl()));

  /// Telemetry
  sl.registerLazySingleton<TelemetryRepository>(() => TelemetryRepositoryImpl(sl()));
  sl.registerLazySingleton<ObserverTelemetryUseCase>(() => ObserverTelemetryUseCase(sl()));
  sl.registerLazySingleton<ObserverTelemetryStatusUseCase>(() => ObserverTelemetryStatusUseCase(sl()));
  sl.registerLazySingleton<StartTelemetryStreamUseCase>(() => StartTelemetryStreamUseCase(sl()));
}