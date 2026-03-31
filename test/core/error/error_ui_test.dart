import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/core/error/error_mapper.dart';
import 'package:mower_bot/core/error/error_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ErrorNotifier', () {
    test('add/remove/clear mutate list and notify', () {
      final notifier = ErrorNotifier();

      var notifications = 0;
      notifier.addListener(() => notifications++);

      notifier.clearErrors();

      final ex = NetworkException.timeout('op');
      notifier.addError(ex);
      expect(notifier.errors, [ex]);

      notifier.removeError(ex);
      expect(notifier.errors, isEmpty);

      notifier.addError(ex);
      notifier.clearErrors();
      expect(notifier.errors, isEmpty);

      expect(notifications, greaterThanOrEqualTo(3));
    });

    test('getErrorMessage and getErrorSeverity delegate to mapper', () {
      final notifier = ErrorNotifier();
      final ex = NetworkException.timeout('op');
      expect(notifier.getErrorMessage(ex), isNotEmpty);
      expect(notifier.getErrorSeverity(ex), isA<ErrorSeverity>());
    });
  });

  group('ErrorDisplay widget', () {
    testWidgets('renders message, icon and dismiss button when provided', (tester) async {
      final ex = NetworkException.timeout('op');

      var dismissed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              exception: ex,
              onDismiss: () => dismissed++,
              showDetails: true,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(IconButton), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      expect(dismissed, 1);

      // When showDetails=true and code exists, code is rendered.
      expect(find.textContaining('Error Code:'), findsOneWidget);
    });

    testWidgets('does not render dismiss button when onDismiss is null', (tester) async {
      final ex = const ValidationException(message: 'bad', code: AppExceptionCode.invalidField);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              exception: ex,
              onDismiss: null,
              showDetails: false,
            ),
          ),
        ),
      );

      expect(find.byType(IconButton), findsNothing);
      expect(find.textContaining('Error Code:'), findsNothing);
    });

    testWidgets('BuildContext.showError shows SnackBar', (tester) async {
      final ex = NetworkException.timeout('op');

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.showError(ex),
                  child: const Text('go'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('go'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
    });
  });
}
