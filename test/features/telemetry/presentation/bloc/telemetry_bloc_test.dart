import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/stop_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockStart extends Mock implements StartTelemetryStreamUseCase {}
class _MockStop extends Mock implements StopTelemetryStreamUseCase {}
class _MockObserve extends Mock implements ObserverTelemetryUseCase {}
class _MockObserveStatus extends Mock implements ObserverTelemetryStatusUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TelemetryBloc', () {
    late _MockStart start;
    late _MockStop stop;
    late _MockObserve observe;
    late _MockObserveStatus observeStatus;
    late Completer<void> startCompleter;
    late StreamController<TelemetryDataModel> telemetryController;
    late StreamController<MowerStatusModel> statusController;

    setUp(() {
      start = _MockStart();
      stop = _MockStop();
      observe = _MockObserve();
      observeStatus = _MockObserveStatus();
      when(() => stop.call()).thenAnswer((_) async {});
    });

    blocTest<TelemetryBloc, TelemetryState>(
      'emits Loading then Loaded when telemetry stream emits',
      build: () {
        when(() => start.call()).thenAnswer((_) async {});
        when(() => observe()).thenAnswer(
          (_) => Stream<TelemetryDataModel>.fromIterable(
            const [
              TelemetryDataModel(
                wheelAngle: 1,
                opticalAngle: 2,
                distanceTraveled: 3,
                speed: 4,
                actuatorDrive: true,
                actuatorStart: false,
              ),
            ],
          ),
        );
        when(() => observeStatus()).thenAnswer((_) => const Stream<MowerStatusModel>.empty());

        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      act: (bloc) => bloc.add(StartTelemetry()),
      expect: () => [
        isA<TelemetryLoading>(),
        isA<TelemetryLoaded>(),
      ],
    );

    blocTest<TelemetryBloc, TelemetryState>(
      'emits Error when startTelemetryStreamUseCase throws (via onError callback)',
      build: () {
        when(() => start.call()).thenAnswer((_) async {
          throw StateError('boom');
        });
        when(() => observe()).thenAnswer((_) => const Stream<TelemetryDataModel>.empty());
        when(() => observeStatus()).thenAnswer((_) => const Stream<MowerStatusModel>.empty());
        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      act: (bloc) => bloc.add(StartTelemetry()),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<TelemetryLoading>(),
        isA<TelemetryError>(),
      ],
    );

    blocTest<TelemetryBloc, TelemetryState>(
      'emits MegaTelemetryStatus when status stream emits',
      build: () {
        when(() => start.call()).thenAnswer((_) async {});
        when(() => observe()).thenAnswer((_) => const Stream<TelemetryDataModel>.empty());
        when(() => observeStatus()).thenAnswer((_) => const Stream<MowerStatusModel>.empty());

        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      act: (bloc) async {
        bloc.add(StartTelemetry());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(
          MegaTelemetryStatusUpdated(
            received: true,
            ageMs: 2,
            ok: true,
          ),
        );
      },
      expect: () => [
        isA<TelemetryLoading>(),
        isA<MegaTelemetryStatus>(),
      ],
    );

    blocTest<TelemetryBloc, TelemetryState>(
      'StopTelemetry cancels subscriptions and returns to initial',
      build: () {
        when(() => start.call()).thenAnswer((_) async {});
        when(() => observe()).thenAnswer((_) => const Stream<TelemetryDataModel>.empty());
        when(() => observeStatus()).thenAnswer((_) => const Stream<MowerStatusModel>.empty());
        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      act: (bloc) async {
        bloc.add(StartTelemetry());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(StopTelemetry());
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<TelemetryLoading>(),
        isA<TelemetryInitial>(),
      ],
      verify: (_) {
        verify(() => stop.call()).called(1);
      },
    );

    blocTest<TelemetryBloc, TelemetryState>(
      'repeated starts retain one repository start and observer set',
      build: () {
        when(() => start.call()).thenAnswer((_) async {});
        when(() => observe()).thenAnswer((_) => const Stream<TelemetryDataModel>.empty());
        when(() => observeStatus()).thenAnswer((_) => const Stream<MowerStatusModel>.empty());
        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      act: (bloc) {
        bloc.add(StartTelemetry());
        bloc.add(StartTelemetry());
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [isA<TelemetryLoading>()],
      verify: (_) {
        verify(() => start.call()).called(1);
        verify(() => observe()).called(1);
        verify(() => observeStatus()).called(1);
      },
    );

    blocTest<TelemetryBloc, TelemetryState>(
      'stop queued during start prevents later telemetry emissions',
      build: () {
        when(() => start.call()).thenAnswer((_) => startCompleter.future);
        when(() => observe()).thenAnswer((_) => telemetryController.stream);
        when(() => observeStatus()).thenAnswer((_) => statusController.stream);
        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      setUp: () {
        startCompleter = Completer<void>();
        telemetryController = StreamController<TelemetryDataModel>.broadcast();
        statusController = StreamController<MowerStatusModel>.broadcast();
      },
      act: (bloc) async {
        bloc.add(StartTelemetry());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(StopTelemetry());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        startCompleter.complete();
        await Future<void>.delayed(const Duration(milliseconds: 5));
        telemetryController.add(
          const TelemetryDataModel(
            wheelAngle: 1,
            opticalAngle: 2,
            distanceTraveled: 3,
            speed: 4,
            actuatorDrive: true,
            actuatorStart: false,
          ),
        );
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<TelemetryLoading>(),
        isA<TelemetryInitial>(),
      ],
      verify: (_) {
        verify(() => stop.call()).called(1);
      },
      tearDown: () async {
        await telemetryController.close();
        await statusController.close();
      },
    );

    blocTest<TelemetryBloc, TelemetryState>(
      'emits Error when the telemetry data stream fails',
      build: () {
        when(() => start.call()).thenAnswer((_) async {});
        when(() => observe()).thenAnswer((_) => telemetryController.stream);
        when(() => observeStatus()).thenAnswer((_) => const Stream<MowerStatusModel>.empty());
        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      setUp: () {
        telemetryController = StreamController<TelemetryDataModel>.broadcast();
      },
      act: (bloc) async {
        bloc.add(StartTelemetry());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        telemetryController.addError(StateError('telemetry stream failed'));
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<TelemetryLoading>(),
        isA<TelemetryError>().having(
          (state) => state.error,
          'error',
          contains('telemetry stream failed'),
        ),
      ],
      tearDown: () => telemetryController.close(),
    );

    blocTest<TelemetryBloc, TelemetryState>(
      'emits Error when the telemetry status stream fails',
      build: () {
        when(() => start.call()).thenAnswer((_) async {});
        when(() => observe()).thenAnswer((_) => const Stream<TelemetryDataModel>.empty());
        when(() => observeStatus()).thenAnswer((_) => statusController.stream);
        return TelemetryBloc(start, stop, observe, observeStatus);
      },
      setUp: () {
        statusController = StreamController<MowerStatusModel>.broadcast();
      },
      act: (bloc) async {
        bloc.add(StartTelemetry());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        statusController.addError(StateError('status stream failed'));
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<TelemetryLoading>(),
        isA<TelemetryError>().having(
          (state) => state.error,
          'error',
          contains('status stream failed'),
        ),
      ],
      tearDown: () => statusController.close(),
    );

    test('close stops the repository telemetry stream', () async {
      when(() => start.call()).thenAnswer((_) async {});
      when(() => observe()).thenAnswer((_) => const Stream<TelemetryDataModel>.empty());
      when(() => observeStatus()).thenAnswer((_) => const Stream<MowerStatusModel>.empty());
      final bloc = TelemetryBloc(start, stop, observe, observeStatus);
      bloc.add(StartTelemetry());
      await Future<void>.delayed(const Duration(milliseconds: 5));

      await bloc.close();

      verify(() => stop.call()).called(1);
    });
  });
}
