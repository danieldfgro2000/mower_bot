import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/platform/wifi_scan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WifiScan widgets', () {
    testWidgets('WifiScanLoading renders and buttons invoke callbacks', (tester) async {
      var opened = 0;
      var cancelled = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WifiScanLoading(
              onOpenWifiSettings: () => opened++,
              onCancel: () => cancelled++,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Open Wi‑Fi Settings'), findsOneWidget);
      expect(find.text('Cancel Scan'), findsOneWidget);

      await tester.tap(find.text('Open Wi‑Fi Settings'));
      await tester.tap(find.text('Cancel Scan'));

      expect(opened, 1);
      expect(cancelled, 1);
    });

    testWidgets('WifiScanFailed renders and all actions invoke callbacks', (tester) async {
      var openLocation = 0;
      var openWifi = 0;
      var retry = 0;
      var cont = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WifiScanFailed(
              message: 'boom',
              onOpenLocationSettings: () => openLocation++,
              onOpenWifiSettings: () => openWifi++,
              onRetry: () => retry++,
              onContinue: () => cont++,
            ),
          ),
        ),
      );

      expect(find.text('boom'), findsOneWidget);
      expect(find.text("Can't scan Wi‑Fi networks, check the following:"), findsOneWidget);

      await tester.tap(find.text('Turn on Location'));
      await tester.tap(find.text('Open Wi‑Fi'));
      await tester.tap(find.text('Retry'));
      await tester.tap(find.text('Continue without scan'));

      expect(openLocation, 1);
      expect(openWifi, 1);
      expect(retry, 1);
      expect(cont, 1);
    });

    testWidgets('WifiScanFailed supports null onOpenLocationSettings (button disabled)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WifiScanFailed(
              message: 'boom',
              onOpenLocationSettings: null,
              onOpenWifiSettings: () {},
              onRetry: () {},
              onContinue: () {},
            ),
          ),
        ),
      );

      final btn = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Turn on Location'));
      expect(btn.onPressed, isNull);
    });
  });
}

