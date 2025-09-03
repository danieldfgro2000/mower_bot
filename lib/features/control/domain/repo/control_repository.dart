
abstract class ControlRepository {
  String? get videoStreamUrl;
  bool get isCtrlWsConnected;
  Future<void> sendDriveCommand(Map<String, dynamic> command);
}