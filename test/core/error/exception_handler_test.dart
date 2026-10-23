import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/core/error/exception_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExceptionHandler', () {
    test('handleException maps common Dart/IO exceptions to AppExceptions', () {
      final h = ExceptionHandler();

      final a = h.handleException(
        SocketException('no', address: InternetAddress.loopbackIPv4, port: 80),
      );
      expect(a, isA<NetworkException>());
      expect(a.code, AppExceptionCode.connectionFailed);

      final b = h.handleException(TimeoutException('t'));
      expect(b, isA<NetworkException>());
      expect(b.code, AppExceptionCode.timeout);

      final c = h.handleException(const FormatException('bad'));
      expect(c, isA<DataException>());
      expect(c.code, AppExceptionCode.serializationFailed);

      final d = h.handleException(StateError('boom'));
      expect(d, isA<DataException>());
      expect(d.code, AppExceptionCode.invalidField);
      expect(d.message, contains('Invalid state'));

      final e = h.handleException(ArgumentError('x'));
      expect(e, isA<ValidationException>());
      expect(e.code, AppExceptionCode.invalidField);
      expect(e.message, contains('Invalid argument'));
    });

    test('handleException passes through AppException and wraps unknown errors', () {
      final h = ExceptionHandler();

      const app = NetworkException(message: 'm', code: AppExceptionCode.hostUnreachable);
      expect(h.handleException(app), same(app));

      final unknown = h.handleException(StateError('something')); // maps to DataException
      expect(unknown, isA<AppException>());

      final unknown2 = h.handleException(Object());
      expect(unknown2, isA<GenericException>());
      expect(unknown2.code, AppExceptionCode.unknownError);
    });

    test('reportException does not throw, even after dispose (controller recreation)', () async {
      final h = ExceptionHandler();

      // Listen once.
      final received = <AppException>[];
      final sub = h.exceptions.listen(received.add);

      h.reportException(NetworkException.timeout('op'));
      await Future<void>.delayed(Duration.zero);
      expect(received, isNotEmpty);

      // Dispose closes controller.
      h.dispose();

      // Reporting again should recreate controller and not throw.
      expect(() => h.reportException(NetworkException.timeout('op2')), returnsNormally);

      await sub.cancel();

      // New listener should still work.
      final received2 = <AppException>[];
      final sub2 = h.exceptions.listen(received2.add);
      h.reportException(NetworkException.timeout('op3'));
      await Future<void>.delayed(Duration.zero);
      expect(received2, isNotEmpty);
      await sub2.cancel();
    });

    test('safeExecute throws mapped exception when suppressError=false', () async {
      final h = ExceptionHandler();

      await expectLater(
        h.safeExecute(() async => throw TimeoutException('t')),
        throwsA(isA<AppException>()),
      );
    });

    test('safeExecute returns defaultValue when suppressError=true', () async {
      final h = ExceptionHandler();

      final out = await h.safeExecute<int>(
        () async => throw TimeoutException('t'),
        defaultValue: 7,
        suppressError: true,
      );

      expect(out, 7);
    });

    test('safeExecuteSync mirrors async behavior', () {
      final h = ExceptionHandler();

      expect(
        () => h.safeExecuteSync(() => throw TimeoutException('t')),
        throwsA(isA<AppException>()),
      );

      final out = h.safeExecuteSync<int>(
        () => throw TimeoutException('t'),
        defaultValue: 7,
        suppressError: true,
      );
      expect(out, 7);
    });
  });

  group('Future ExceptionHandling extension', () {
    test('handleExceptions converts thrown errors to AppException', () async {
      final f = Future<int>.error(TimeoutException('t'));
      await expectLater(
        () => f.handleExceptions<int>(),
        throwsA(isA<AppException>()),
      );
    });

    test('safely returns defaultValue on error', () async {
      final f = Future<int>.error(TimeoutException('t'));
      final out = await f.safely<int>(defaultValue: 5);
      expect(out, 5);
    });
  });
}
