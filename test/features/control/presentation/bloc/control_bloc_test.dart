import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_state.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';

class _MockSendDriveCommandUseCase extends Mock
    implements SendDriveCommandUseCase {}

class _MockObserverTelemetryUseCase extends Mock
    implements ObserverTelemetryUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('ControlBloc', () {
    late _MockSendDriveCommandUseCase send;
    late _MockObserverTelemetryUseCase observe;

    setUp(() {
      send = _MockSendDriveCommandUseCase();
      observe = _MockObserverTelemetryUseCase();
      when(() => observe()).thenAnswer((_) => const Stream.empty());
    });

    blocTest<ControlBloc, ControlState>(
      'DriveCommand success clears errorMessage',
      build: () {
        when(
          () => send(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
        return ControlBloc(send, observe);
      },
      act: (bloc) => bloc.add(const DriveCommand(isMoving: true)),
      expect: () => [
        isA<ControlState>().having((s) => s.errorMessage, 'errorMessage', ''),
      ],
    );

    blocTest<ControlBloc, ControlState>(
      'DriveCommand failure sets errorMessage',
      build: () {
        when(
          () => send(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.disconnected);
        return ControlBloc(send, observe);
      },
      act: (bloc) => bloc.add(const DriveCommand(isMoving: true)),
      expect: () => [
        isA<ControlState>().having(
          (s) => s.errorMessage,
          'errorMessage',
          contains('not submitted'),
        ),
      ],
    );

    blocTest<ControlBloc, ControlState>(
      'TelemetryDataReceived updates isMowerMoving and isMowerRunning',
      build: () {
        when(
          () => send(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
        return ControlBloc(send, observe);
      },
      act: (bloc) {
        const telemetry = TelemetryDataModel(
          wheelAngle: 0,
          opticalAngle: 0,
          distanceTraveled: 0,
          speed: 0,
          actuatorStart: true,
          actuatorDrive: true,
        );
        bloc.add(TelemetryDataReceived(telemetry));
      },
      expect: () => [
        isA<ControlState>()
            .having((s) => s.isMowerMoving, 'isMowerMoving', true)
            .having((s) => s.isMowerRunning, 'isMowerRunning', true),
      ],
    );

    test('steering input updates commanded angle independently', () async {
      when(
        () => send(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      final bloc = ControlBloc(send, observe);
      addTearDown(bloc.close);

      bloc.add(TelemetryDataReceived(_movingTelemetry));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SteerCommand(angle: 18));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.commandedSteeringAngle, 18);
      expect(bloc.state.observedSteeringAngle, 0);
    });

    blocTest<ControlBloc, ControlState>(
      'RunCommand submission does not replace telemetry-confirmed running state',
      build: () {
        when(
          () => send(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
        return ControlBloc(send, observe);
      },
      act: (bloc) => bloc.add(const RunCommand(isRunning: true)),
      expect: () => [
        isA<ControlState>().having(
          (state) => state.isMowerRunning,
          'isMowerRunning',
          isFalse,
        ),
      ],
    );

    blocTest<ControlBloc, ControlState>(
      'EmergencyStop submission preserves physical state until telemetry confirms it',
      build: () {
        when(
          () => send(any()),
        ).thenAnswer((_) async => CommandSubmissionResult.submitted);
        return ControlBloc(send, observe);
      },
      act: (bloc) async {
        bloc.add(TelemetryDataReceived(_movingTelemetry));
        await Future<void>.delayed(Duration.zero);
        bloc.add(EmergencyStop());
      },
      expect: () => [
        isA<ControlState>()
            .having((state) => state.isMowerMoving, 'isMowerMoving', isTrue)
            .having((state) => state.isMowerRunning, 'isMowerRunning', isTrue),
        isA<ControlState>()
            .having((state) => state.isMowerMoving, 'isMowerMoving', isTrue)
            .having((state) => state.isMowerRunning, 'isMowerRunning', isTrue),
      ],
    );

    test('EmergencyStop cancels a pending steering submission', () async {
      when(
        () => send(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);
      final bloc = ControlBloc(send, observe);
      addTearDown(bloc.close);

      bloc.add(const SteerCommand(angle: 12));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(EmergencyStop());
      await Future<void>.delayed(const Duration(milliseconds: 150));

      verify(
        () => send({
          'mega': {'command': 'emergency_stop'},
        }),
      ).called(1);
      verifyNever(
        () => send({
          'mega': {'command': 'steer', 'angle': 12.0},
        }),
      );
    });
  });
}

const _movingTelemetry = TelemetryDataModel(
  wheelAngle: 0,
  opticalAngle: 0,
  distanceTraveled: 0,
  speed: 1,
  actuatorStart: true,
  actuatorDrive: true,
);
