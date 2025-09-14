

abstract class MowerConnectionRepository {
  Stream<Map<String, dynamic>>? jsonStream();
  Stream<Object> ctrlWsErr();
  Stream<bool>? ctrlWsConnected();
  Future<void> connectCtrlWs(String ipAddress);
  Future<void> disconnectCtrlWs();
  bool get isCtrlWsConnected;
}