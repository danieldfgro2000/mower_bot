import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MowerConnectionState', () {
    test('default values are stable', () {
      const s = MowerConnectionState();
      expect(s.connectionStatus, ConnectionStatus.disconnected);
      expect(s.wifiMode, ESP32WiFiMode.client);
      expect(s.wifiScanStatus, WifiScanStatus.idle);
      expect(s.ip, isNull);
      expect(s.port, isNull);
      expect(s.error, isNull);
      expect(s.detectedApSsid, isNull);
      expect(s.apSsid, 'MowerBot-AP');
      expect(s.apPassword, 'mowerbot123');
    });

    test('copyWith keeps existing values when null', () {
      const base = MowerConnectionState(ip: '1.2.3.4', port: 80, error: 'e');
      final next = base.copyWith();
      expect(next, equals(base));
    });

    test('copyWith overrides requested fields', () {
      const base = MowerConnectionState(ip: '1.2.3.4', port: 80);
      final next = base.copyWith(
        status: ConnectionStatus.ctrlWsConnected,
        wifiMode: ESP32WiFiMode.ap,
        wifiScanStatus: WifiScanStatus.completed,
        ip: '9.9.9.9',
        port: 85,
        error: 'boom',
        detectedApSsid: 'MowerBot-AP',
        apSsid: 'X',
        apPassword: 'Y',
      );

      expect(next.connectionStatus, ConnectionStatus.ctrlWsConnected);
      expect(next.wifiMode, ESP32WiFiMode.ap);
      expect(next.wifiScanStatus, WifiScanStatus.completed);
      expect(next.ip, '9.9.9.9');
      expect(next.port, 85);
      expect(next.error, 'boom');
      expect(next.detectedApSsid, 'MowerBot-AP');
      expect(next.apSsid, 'X');
      expect(next.apPassword, 'Y');
    });

    test('props/toDiffMap includes all fields', () {
      const s = MowerConnectionState(
        connectionStatus: ConnectionStatus.videoWsConnected,
        wifiMode: ESP32WiFiMode.ap,
        wifiScanStatus: WifiScanStatus.failed,
        ip: '10.0.0.1',
        port: 123,
        error: 'err',
        detectedApSsid: 'ssid',
        apSsid: 'ap',
        apPassword: 'pw',
      );

      // Equatable uses props; equality sanity check.
      expect(s, equals(s.copyWith()));

      final m = s.toDiffMap();
      expect(m['status'], ConnectionStatus.videoWsConnected);
      expect(m['wifiMode'], ESP32WiFiMode.ap);
      expect(m['wifiScanStatus'], WifiScanStatus.failed);
      expect(m['ip'], '10.0.0.1');
      expect(m['port'], 123);
      expect(m['error'], 'err');
      expect(m['detectedApSsid'], 'ssid');
      expect(m['apSsid'], 'ap');
      expect(m['apPassword'], 'pw');
    });
  });
}

