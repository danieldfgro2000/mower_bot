abstract class MowerConnectionRepository {
  Future<void> connect(String ipAddress, int port);
  Future<void> disconnect();
  Future<bool> checkConnectionStatus();
  Stream<bool> connectionChanges();
}