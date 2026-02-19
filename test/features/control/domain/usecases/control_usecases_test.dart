import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockControlRepository extends Mock implements ControlRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Control usecases', () {
    late _MockControlRepository repo;

    setUp(() {
      repo = _MockControlRepository();
    });

    test('GetVideoStreamUrlUseCase returns repository.videoStreamUrl', () {
      when(() => repo.videoStreamUrl).thenReturn('http://x');

      final uc = GetVideoStreamUrlUseCase(repo);
      expect(uc(), 'http://x');

      verify(() => repo.videoStreamUrl).called(1);
    });

    test('SendDriveCommandUseCase does not send when not connected and returns false', () async {
      when(() => repo.isCtrlWsConnected).thenReturn(false);

      final uc = SendDriveCommandUseCase(repo);
      final ok = await uc({'cmd': 'x'});

      expect(ok, isFalse);
      verifyNever(() => repo.sendDriveCommand(any()));
    });

    test('SendDriveCommandUseCase sends when connected and returns true', () async {
      when(() => repo.isCtrlWsConnected).thenReturn(true);
      when(() => repo.sendDriveCommand(any())).thenAnswer((_) async {});

      final uc = SendDriveCommandUseCase(repo);
      final ok = await uc({'cmd': 'x'});

      expect(ok, isTrue);
      verify(() => repo.sendDriveCommand({'cmd': 'x'})).called(1);
    });
  });
}

