import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/paths/domain/repository/path_repository.dart';

class SavePathUseCase {
  final PathRepository repository;

  SavePathUseCase(this.repository);

  /// Begin capturing steering-angle samples on the ESP32 SD card.
  Future<CommandSubmissionResult> startRecording() => repository.startRecord();

  /// Stop capturing and persist the file under [name] on the SD card.
  Future<CommandSubmissionResult> saveRecording(String name) =>
      repository.stopRecord(name);

  /// Stop capturing and delete the temporary recording.
  Future<CommandSubmissionResult> discardRecording() =>
      repository.stopRecord('');
}
