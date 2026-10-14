import 'package:wifi_scan/wifi_scan.dart';

class WifiScanner {
  Future<bool> startScan() => WiFiScan.instance.startScan();

  Future<List<WiFiAccessPoint>> getScannedResults() =>
      WiFiScan.instance.getScannedResults();
}
