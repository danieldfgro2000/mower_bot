

import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

abstract class MowerConnectionRepository {
  Stream<Map<String, dynamic>>? jsonStream();
  Stream<Object> ctrlWsErr();
  Stream<ConnectionStatus>? ctrlWsConnected();
  Future<void> connectCtrlWs(String ipAddress);
  Future<void> disconnectCtrlWs();
  bool get isCtrlWsConnected;
}