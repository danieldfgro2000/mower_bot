
import 'dart:typed_data';

abstract class MowerConnectionRepository {
  Stream<Map<String, dynamic>>? jsonStream();
  Stream<Uint8List>? videoStream();
  Stream<Object> ctrlWsErr();
  Stream<Object> videoWsErr();
  Future<void> connectCtrlWs(String ipAddress);
  Future<void> connectVideoWs(String ipAddress);
  Future<void> disconnectCtrlWs();
  Future<void> disconnectVideoWs();
  bool get isCtrlWsConnected;
  bool get isVideoWsConnected;
}