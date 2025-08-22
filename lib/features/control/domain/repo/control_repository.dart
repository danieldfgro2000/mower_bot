import 'dart:typed_data';

abstract class ControlRepository {
  Future<void> startVideoStream();
  Stream<Uint8List> get videFrames;
  bool get isConnected;
}