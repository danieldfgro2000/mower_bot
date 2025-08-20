abstract class MowerConnectionRepository {
  Future<void> connect(String ipAddress, int port);
  Future<void> disconnect();
  Future<bool> checkConnectionStatus();
  Future<Uri?> getTelemetryUrl();
  Stream<bool> connectionChanges();
  Stream<bool> get connectionStatusStream;
}