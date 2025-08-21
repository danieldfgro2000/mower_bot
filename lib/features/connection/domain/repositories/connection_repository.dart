abstract class MowerConnectionRepository {
  Future<void> connect(String ipAddress, int port);
  Future<void> disconnect();
  bool get isConnected;
}