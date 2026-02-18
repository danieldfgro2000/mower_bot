import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/features/connection/presentation/pages/components/info.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('InfoWidget renders key instructions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InfoWidget(),
        ),
      ),
    );

    expect(find.textContaining('manual confirm'), findsOneWidget);
    expect(find.textContaining('Host unreachable'), findsOneWidget);
    expect(find.textContaining('Disconnected'), findsOneWidget);
    expect(find.textContaining('Connect WebSocket'), findsOneWidget);
    expect(find.textContaining('Connected'), findsOneWidget);
  });
}

