import 'dart:typed_data';

import 'package:mower_bot/features/control/domain/repo/control_repository.dart';

class ObserverVideoFramesUseCase {
  final ControlRepository _repository;
  ObserverVideoFramesUseCase(this._repository);

  Stream<Uint8List> call() {
    return _repository.videFrames;
  }
}