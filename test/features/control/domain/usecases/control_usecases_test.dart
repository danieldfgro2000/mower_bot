import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
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

    test('SendDriveCommandUseCase returns disconnected outcome', () async {
      when(
        () => repo.sendDriveCommand(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.disconnected);

      final uc = SendDriveCommandUseCase(repo);
      final result = await uc({'cmd': 'x'});

      expect(result, CommandSubmissionResult.disconnected);
      verify(() => repo.sendDriveCommand({'cmd': 'x'})).called(1);
    });

    test('SendDriveCommandUseCase returns submitted outcome', () async {
      when(
        () => repo.sendDriveCommand(any()),
      ).thenAnswer((_) async => CommandSubmissionResult.submitted);

      final uc = SendDriveCommandUseCase(repo);
      final result = await uc({'cmd': 'x'});

      expect(result, CommandSubmissionResult.submitted);
      verify(() => repo.sendDriveCommand({'cmd': 'x'})).called(1);
    });
  });
}
