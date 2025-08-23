import 'package:get_it/get_it.dart';
import 'package:mower_bot/core/network/websocket_client.dart';
import 'package:mower_bot/core/network/websocket_config.dart';
import 'package:mower_bot/features/connection/data/repositories/connection_repository_impl.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_mower_status.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_mower.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_mower.dart';
import 'package:mower_bot/features/control/data/repositories/control_repository_impl.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';
import 'package:mower_bot/features/control/domain/usecases/observer_video_frames_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/start_video_stream_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/stop_video_stream_use_case.dart';
import 'package:mower_bot/features/paths/data/repositories/path_repository_impl.dart';
import 'package:mower_bot/features/paths/domain/usecases/delete_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/get_paths.dart';
import 'package:mower_bot/features/paths/domain/usecases/play_path.dart';
import 'package:mower_bot/features/paths/domain/usecases/stop_path.dart';
import 'package:mower_bot/features/telemetry/data/repositories/telemetry_repository.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// Core
  sl.registerLazySingleton<WebSocketConfig>(() => WebSocketConfig());
  sl.registerLazySingleton<WebSocketClient>(() => WebSocketClient(sl()));
  sl.registerLazySingleton<IWebSocketClient>(() => sl<WebSocketClient>());

  /// Connection
  sl.registerLazySingleton<MowerConnectionRepository>(() => MowerConnectionRepositoryImpl(sl()));
  sl.registerLazySingleton<ConnectToMowerUseCase>(() => ConnectToMowerUseCase(sl()));
  sl.registerLazySingleton<DisconnectMowerUseCase>(() => DisconnectMowerUseCase(sl()));
  sl.registerLazySingleton<CheckMowerStatusUseCase>(() => CheckMowerStatusUseCase(sl()));

  /// Paths
  sl.registerLazySingleton<MockPathRepository>(() => MockPathRepository());
  sl.registerLazySingleton<GetPathsUseCase>(() => GetPathsUseCase(sl()));
  sl.registerLazySingleton<PlayPathUseCase>(() => PlayPathUseCase(sl()));
  sl.registerLazySingleton<StopPathUseCase>(() => StopPathUseCase(sl()));
  sl.registerLazySingleton<DeletePathUseCase>(() => DeletePathUseCase(sl()));

  /// Control
  sl.registerLazySingleton<ControlRepository>(() => ControlRepositoryImpl(sl()));
  sl.registerLazySingleton<ObserverVideoFramesUseCase>(() => ObserverVideoFramesUseCase(sl()));
  sl.registerLazySingleton<StartVideoStreamUseCase>(() => StartVideoStreamUseCase(sl()));
  sl.registerLazySingleton<StopVideoStreamUseCase>(() => StopVideoStreamUseCase(sl()));

  /// Telemetry
  sl.registerLazySingleton<TelemetryRepository>(() => TelemetryRepositoryImpl(sl()));
  sl.registerLazySingleton<ObserverTelemetryUseCase>(() => ObserverTelemetryUseCase(sl()));
  sl.registerLazySingleton<ObserverTelemetryStatusUseCase>(() => ObserverTelemetryStatusUseCase(sl()));
  sl.registerLazySingleton<StartTelemetryStreamUseCase>(() => StartTelemetryStreamUseCase(sl()));
}