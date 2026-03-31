import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_state.dart';
import 'package:mower_bot/features/paths/domain/usecases/save_path.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';

class _MockSendDriveCommandUseCase extends Mock
    implements SendDriveCommandUseCase {}

class _MockGetVideoStreamUrlUseCase extends Mock
    implements GetVideoStreamUrlUseCase {}

class _MockObserverTelemetryUseCase extends Mock
    implements ObserverTelemetryUseCase {}

class _MockSavePathUseCase extends Mock implements SavePathUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('ControlBloc', () {
    late _MockSendDriveCommandUseCase send;
    late _MockGetVideoStreamUrlUseCase getVideo;
    late _MockObserverTelemetryUseCase observe;
    late _MockSavePathUseCase savePath;

    setUp(() {
      send = _MockSendDriveCommandUseCase();
      getVideo = _MockGetVideoStreamUrlUseCase();
      observe = _MockObserverTelemetryUseCase();
      savePath = _MockSavePathUseCase();

      when(() => getVideo()).thenReturn('http://example/stream');
      when(() => observe()).thenAnswer((_) => const Stream.empty());
    });

    blocTest<ControlBloc, ControlState>(
      'DriveCommand success clears errorMessage',
      build: () {
        when(() => send(any())).thenAnswer((_) async => true);
        return ControlBloc(send, getVideo, observe, savePath);
      },
      act: (bloc) => bloc.add(const DriveCommand(isMoving: true)),
      expect: () => [isA<ControlState>().having((s) => s.errorMessage, 'errorMessage', '')],
    );

    blocTest<ControlBloc, ControlState>(
      'DriveCommand failure sets errorMessage',
      build: () {
        when(() => send(any())).thenAnswer((_) async => false);
        return ControlBloc(send, getVideo, observe, savePath);
      },
      act: (bloc) => bloc.add(const DriveCommand(isMoving: true)),
      expect: () => [
        isA<ControlState>().having(
          (s) => s.errorMessage,
          'errorMessage',
          contains('Drive failed'),
        ),
      ],
    );

    blocTest<ControlBloc, ControlState>(
      'TelemetryDataReceived updates isMowerMoving and isMowerRunning',
      build: () {
        when(() => send(any())).thenAnswer((_) async => true);
        return ControlBloc(send, getVideo, observe, savePath);
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
  });
}
