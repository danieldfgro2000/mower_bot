import 'package:mower_bot/core/device/model/connection_status.dart';

class DeviceSessionCoordinator {
  final void Function() startTelemetry;
  final void Function() stopTelemetry;

  const DeviceSessionCoordinator({
    required this.startTelemetry,
    required this.stopTelemetry,
  });

  void synchronize(ConnectionStatus status) {
    if (status == ConnectionStatus.ctrlWsConnected) {
      startTelemetry();
    } else {
      stopTelemetry();
    }
  }
}
