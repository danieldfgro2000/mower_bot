import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class GetVideoStreamUrlUseCase {
  final ControlRepository repository;

  GetVideoStreamUrlUseCase(this.repository);

  String? call() => repository.videoStreamUrl;
}