abstract class MowerConnectionRepository {
  Stream<Map<String, dynamic>>? messages();
  Stream<Object> errors();
  Future<void> connect(String ipAddress, int port);
  Future<void> disconnect();
  bool get isConnected;
}