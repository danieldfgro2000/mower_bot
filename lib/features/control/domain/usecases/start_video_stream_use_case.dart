import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class StartVideoStreamUseCase {
  final ControlRepository _repository;
  StartVideoStreamUseCase(this._repository);
  Future<void> call(int fps) async => _repository.startVideoStream(fps);
}