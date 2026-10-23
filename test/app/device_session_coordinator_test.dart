import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/app/device_session_coordinator.dart';
import 'package:mower_bot/core/device/model/connection_status.dart';

void main() {
  test('starts telemetry only for an established control connection', () {
    var starts = 0;
    var stops = 0;
    final coordinator = DeviceSessionCoordinator(
      startTelemetry: () => starts++,
      stopTelemetry: () => stops++,
    );

    coordinator.synchronize(ConnectionStatus.ctrlWsConnected);
    coordinator.synchronize(ConnectionStatus.connecting);
    coordinator.synchronize(ConnectionStatus.disconnected);

    expect(starts, 1);
    expect(stops, 2);
  });
}
