
import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class StopVideoStreamUseCase {
  final ControlRepository _repository;
  StopVideoStreamUseCase(this._repository);

  Future<void> call() async => _repository.stopVideoStream();
}