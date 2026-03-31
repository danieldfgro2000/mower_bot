import 'package:mower_bot/core/data/repo/path_repository_impl.dart';

class SavePathUseCase {
  final PathRepository repository;

  SavePathUseCase(this.repository);

  /// Begin capturing steering-angle samples on the ESP32 SD card.
  Future<void> startRecording() => repository.startRecord();

  /// Stop capturing and persist the file under [name] on the SD card.
  Future<void> stopRecording(String name) => repository.stopRecord(name);
}

