import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/core/error/global_error_interceptor.dart';

class _TestErrorHandlingMixin with ErrorHandlingMixin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlobalErrorInterceptor', () {
    test('initialize is idempotent and sets isInitialized', () {
      final interceptor = GlobalErrorInterceptor();
      interceptor.initialize();
      expect(interceptor.isInitialized, isTrue);

      // Calling again should be a no-op.
      interceptor.initialize();
      expect(interceptor.isInitialized, isTrue);

      interceptor.dispose();
      expect(interceptor.isInitialized, isFalse);
    });

    test('reportException does not throw', () {
      final interceptor = GlobalErrorInterceptor();
      interceptor.initialize();

      expect(
        () => interceptor.reportException(
          const WebSocketException(message: 'boom', code: AppExceptionCode.connectionLost),
        ),
        returnsNormally,
      );

      interceptor.dispose();
    });

    test('FlutterError.onError handler is installed after initialize', () {
      final interceptor = GlobalErrorInterceptor();
      interceptor.initialize();

      expect(FlutterError.onError, isNotNull);

      // Trigger it with a synthetic FlutterErrorDetails.
      FlutterError.onError!(
        FlutterErrorDetails(
          exception: StateError('synthetic'),
          stack: StackTrace.current,
        ),
      );

      interceptor.dispose();
    });

    test('PlatformDispatcher.onError handler is installed after initialize', () {
      final interceptor = GlobalErrorInterceptor();
      interceptor.initialize();

      final handler = PlatformDispatcher.instance.onError;
      expect(handler, isNotNull);

      final handled = handler!(StateError('synthetic'), StackTrace.current);
      expect(handled, isTrue);

      interceptor.dispose();
    });
  });

  group('ErrorHandlingMixin', () {
    test('handleError returns a user-friendly string', () {
      final obj = _TestErrorHandlingMixin();
      final msg = obj.handleError(TimeoutException('timeout'));
      expect(msg, isNotEmpty);
    });

    test('executeWithErrorHandling returns operation value', () async {
      final obj = _TestErrorHandlingMixin();

      final result = await obj.executeWithErrorHandling(() async => 123);
      expect(result, 123);
    });

    test('executeWithErrorHandling returns defaultValue on error and calls onError', () async {
      final obj = _TestErrorHandlingMixin();

      AppException? seen;
      final result = await obj.executeWithErrorHandling(
        () async => throw TimeoutException('nope'),
        defaultValue: 7,
        onError: (e) => seen = e,
      );

      expect(result, 7);
      expect(seen, isNotNull);
      expect(seen, isA<AppException>());
    });

    test('executeSyncWithErrorHandling returns operation value', () {
      final obj = _TestErrorHandlingMixin();
      final result = obj.executeSyncWithErrorHandling(() => 'ok');
      expect(result, 'ok');
    });

    test('executeSyncWithErrorHandling returns defaultValue on error and calls onError', () {
      final obj = _TestErrorHandlingMixin();

      AppException? seen;
      final result = obj.executeSyncWithErrorHandling(
        () => throw ArgumentError('bad'),
        defaultValue: 'fallback',
        onError: (e) => seen = e,
      );

      expect(result, 'fallback');
      expect(seen, isNotNull);
    });

    test('disposeErrorHandling does not throw', () {
      final obj = _TestErrorHandlingMixin();
      expect(obj.disposeErrorHandling, returnsNormally);
    });
  });
}
