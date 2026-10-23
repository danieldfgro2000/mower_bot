import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mower_bot/core/data/network/websocket_client.dart';
import 'package:mower_bot/core/data/network/websocket_config.dart';
import 'package:mower_bot/app/di/injection_container.dart' as di;
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/paths/domain/repository/path_repository.dart';
import 'package:mower_bot/features/control/presentation/bloc/recording_cubit.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/stop_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('initDependencies', () {
    tearDown(() async {
      await GetIt.I.reset();
    });

    test('registers remote path repository', () async {
      await di.initDependencies();

      final repo = GetIt.I<PathRepository>();
      expect(repo.runtimeType.toString(), contains('PathRepositoryRemote'));
    });

    test('injects registered websocket configuration into clients', () async {
      await di.initDependencies();
      await GetIt.I.unregister<WebSocketConfig>();
      const config = WebSocketConfig(
        retry1sec: Duration(milliseconds: 17),
        max5attempts: 9,
      );
      GetIt.I.registerSingleton<WebSocketConfig>(config);

      expect(GetIt.I<ControlWebSocketClient>().config, same(config));
      expect(GetIt.I<BinaryWebSocketClient>().config, same(config));
    });

    test('registers telemetry stop lifecycle dependencies', () async {
      await di.initDependencies();

      expect(
        GetIt.I<StopTelemetryStreamUseCase>(),
        isA<StopTelemetryStreamUseCase>(),
      );
      expect(GetIt.I<TelemetryBloc>(), isA<TelemetryBloc>());
      expect(GetIt.I<RecordingCubit>(), isA<RecordingCubit>());
    });

    test('disposes app-scoped lifecycle owners on reset', () async {
      await di.initDependencies();

      final telemetryBloc = GetIt.I<TelemetryBloc>();
      final telemetryRepository = GetIt.I<TelemetryRepository>();
      final connectionRepository = GetIt.I<MowerConnectionRepository>();
      final controlClient = GetIt.I<ControlWebSocketClient>();
      final binaryClient = GetIt.I<BinaryWebSocketClient>();
      final streamDone = [
        Completer<void>(),
        Completer<void>(),
        Completer<void>(),
        Completer<void>(),
        Completer<void>(),
      ];
      final subscriptions = [
        telemetryRepository.observeTelemetry().listen(
          (_) {},
          onDone: streamDone[0].complete,
        ),
        telemetryRepository.observeMowerStatus().listen(
          (_) {},
          onDone: streamDone[1].complete,
        ),
        connectionRepository.ctrlWsErr().listen(
          (_) {},
          onDone: streamDone[2].complete,
        ),
        controlClient.messages.listen((_) {}, onDone: streamDone[3].complete),
        binaryClient.messages.listen((_) {}, onDone: streamDone[4].complete),
      ];
      var resourcesDisposed = false;

      try {
        await GetIt.I.reset();

        expect(telemetryBloc.isClosed, isTrue);
        await Future.wait(
          streamDone.map((done) => done.future),
        ).timeout(const Duration(seconds: 1));
        resourcesDisposed = true;
      } finally {
        if (!resourcesDisposed) {
          await telemetryBloc.close();
          await telemetryRepository.dispose();
          await connectionRepository.dispose();
          await controlClient.dispose();
          await binaryClient.dispose();
        }
        await Future.wait(
          subscriptions.map((subscription) => subscription.cancel()),
        );
      }
    });
  });
}
