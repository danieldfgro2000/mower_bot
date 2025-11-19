import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/core/error/error.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

abstract class MowerConnectionRepository {
  Stream<Map<String, dynamic>>? jsonStream();
  Stream<AppException> ctrlWsErr();
  Stream<ConnectionStatus>? ctrlWsConnected();
  Future<void> connectCtrlWs(String ipAddress, int port);
  Future<void> disconnectCtrlWs();
  bool get isCtrlWsConnected;
}