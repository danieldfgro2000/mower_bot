import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockStart extends Mock implements StartTelemetryStreamUseCase {}
class _MockObserve extends Mock implements ObserverTelemetryUseCase {}
class _MockObserveStatus extends Mock implements ObserverTelemetryStatusUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TelemetryBloc', () {
    late _MockStart start;
    late _MockObserve observe;
    late _MockObserveStatus observeStatus;

    setUp(() {
      start = _MockStart();
      observe = _MockObserve();
      observeStatus = _MockObserveStatus();
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

        return TelemetryBloc(start, observe, observeStatus);
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
        return TelemetryBloc(start, observe, observeStatus);
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

        return TelemetryBloc(start, observe, observeStatus);
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
        return TelemetryBloc(start, observe, observeStatus);
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
    );
  });
}
