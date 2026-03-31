import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/connection/domain/model/mower_status_model.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observe_telemetry_status_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/start_telemetry_stream_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockTelemetryRepository extends Mock implements TelemetryRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Telemetry usecases', () {
    late _MockTelemetryRepository repo;

    setUp(() {
      repo = _MockTelemetryRepository();
    });

    test('StartTelemetryStreamUseCase delegates to repository.startTelemetry', () async {
      when(() => repo.startTelemetry()).thenAnswer((_) async {});

      final uc = StartTelemetryStreamUseCase(repo);
      await uc();

      verify(() => repo.startTelemetry()).called(1);
    });

    test('ObserverTelemetryUseCase delegates to repository.observeTelemetry', () async {
      final stream = Stream<TelemetryDataModel>.fromIterable(
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
      );
      when(() => repo.observeTelemetry()).thenAnswer((_) => stream);

      final uc = ObserverTelemetryUseCase(repo);
      expect(uc(), same(stream));
      verify(() => repo.observeTelemetry()).called(1);
    });

    test('ObserverTelemetryStatusUseCase delegates to repository.observeMowerStatus', () async {
      final stream = Stream<MowerStatusModel>.empty();
      when(() => repo.observeMowerStatus()).thenAnswer((_) => stream);

      final uc = ObserverTelemetryStatusUseCase(repo);
      expect(uc(), same(stream));
      verify(() => repo.observeMowerStatus()).called(1);
    });
  });
}

