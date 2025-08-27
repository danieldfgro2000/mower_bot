import 'dart:typed_data';

abstract class ControlRepository {
  Future<void> startVideoStream(int fps);
  Future<void> stopVideoStream();
  Stream<Uint8List> get videFrames;
  bool get isCtrlWsConnected;
  bool get isVideoWsConnected;
}