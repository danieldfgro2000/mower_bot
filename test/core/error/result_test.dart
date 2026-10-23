import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/core/error/result.dart';

void main() {
  group('Result', () {
    test('success basic accessors', () {
      final r = const Success<int>(1);
      expect(r.isSuccess, isTrue);
      expect(r.isFailure, isFalse);
      expect(r.data, 1);
      expect(r.dataOrNull, 1);
      expect(r.exceptionOrNull, isNull);
      expect(r.toString(), contains('Success'));
      expect(r, const Success(1));
      expect(r.hashCode, 1.hashCode);
    });

    test('failure basic accessors', () {
      final ex = NetworkException.hostUnreachable('h');
      final r = Failure<int>(ex);
      expect(r.isSuccess, isFalse);
      expect(r.isFailure, isTrue);
      expect(r.exception, ex);
      expect(r.dataOrNull, isNull);
      expect(r.exceptionOrNull, ex);
      expect(r.toString(), contains('Failure'));
      expect(r, Failure<int>(ex));
      expect(r.hashCode, ex.hashCode);
    });

    test('data getter throws on failure and exception getter throws on success', () {
      expect(() => Failure<int>(NetworkException.timeout('op')).data, throwsStateError);
      expect(() => const Success<int>(1).exception, throwsStateError);
    });

    test('map transforms on success and preserves failure', () {
      final ok = const Success<int>(2).map((x) => '$x');
      expect(ok, const Success('2'));

      final ex = NetworkException.timeout('op');
      final fail = Failure<int>(ex).map((x) => '$x');
      expect(fail, Failure<String>(ex));
    });

    test('map catches transform exceptions and wraps in Failure(GenericException)', () {
      final r = const Success<int>(1).map<String>((_) => throw FormatException('boom'));
      expect(r.isFailure, isTrue);
      expect(r.exception, isA<GenericException>());
      expect(r.exception.code, AppExceptionCode.serializationFailed);
    });

    test('mapAsync transforms on success and preserves failure', () async {
      final ok = await const Success<int>(2).mapAsync((x) async => x + 1);
      expect(ok, const Success(3));

      final ex = NetworkException.timeout('op');
      final fail = await Failure<int>(ex).mapAsync((x) async => x + 1);
      expect(fail, Failure<int>(ex));
    });

    test('mapAsync catches errors and wraps in Failure(GenericException)', () async {
      final r = await const Success<int>(1).mapAsync<int>((_) async {
        throw TimeoutException('nope');
      });
      expect(r.isFailure, isTrue);
      expect(r.exception, isA<GenericException>());
      expect(r.exception.code, AppExceptionCode.transformationFailed);
    });

    test('onSuccess runs side-effect and returns self', () {
      var seen = 0;
      final r = const Success<int>(3).onSuccess((v) => seen = v);
      expect(seen, 3);
      expect(r, const Success(3));

      final ex = NetworkException.timeout('op');
      final r2 = Failure<int>(ex).onSuccess((_) => seen = -1);
      expect(seen, 3);
      expect(r2, Failure<int>(ex));
    });

    test('onSuccess catches callback error and returns Failure(GenericException)', () {
      final r = const Success<int>(3).onSuccess((_) => throw StateError('bad'));
      expect(r.isFailure, isTrue);
      expect(r.exception, isA<GenericException>());
      expect(r.exception.code, AppExceptionCode.serializationFailed);
    });

    test('onFailure runs side-effect and ignores callback errors', () {
      var seen = '';
      final ex = NetworkException.timeout('op');
      final r = Failure<int>(ex).onFailure((e) {
        seen = e.message;
      });
      expect(seen, contains('Operation timed out'));
      expect(r, Failure<int>(ex));

      // Callback throws -> should not change original failure.
      final r2 = Failure<int>(ex).onFailure((_) => throw StateError('boom'));
      expect(r2, Failure<int>(ex));
    });

    test('fold produces a value for both branches', () {
      final ok = const Success<int>(1).fold((d) => 'ok:$d', (e) => 'fail:${e.message}');
      expect(ok, 'ok:1');

      final ex = NetworkException.timeout('op');
      final fail = Failure<int>(ex).fold((d) => 'ok:$d', (e) => 'fail:${e.code}');
      expect(fail, 'fail:${AppExceptionCode.timeout}');
    });

    test('extension helpers and ResultUtils', () async {
      expect(1.toSuccess(), const Success(1));
      final ex = NetworkException.timeout('op');
      expect(ex.toFailure<int>(), Failure<int>(ex));

      expect(ResultUtils.success(1), const Success(1));
      expect(ResultUtils.failure<int>(ex), Failure<int>(ex));

      expect(ResultUtils.execute(() => 7), const Success(7));
      final rFail = ResultUtils.execute<int>(() => throw ArgumentError('x'));
      expect(rFail.isFailure, isTrue);

      final rOkA = await ResultUtils.executeAsync(() async => 7);
      expect(rOkA, const Success(7));
      final rFailA = await ResultUtils.executeAsync<int>(() async => throw ex);
      expect(rFailA, Failure<int>(ex));

      final combinedOk = ResultUtils.combine([const Success(1), const Success(2)]);
      expect(combinedOk.isSuccess, isTrue);
      expect(combinedOk.data, [1, 2]);

      expect(ResultUtils.combine<int>([const Success(1), Failure<int>(ex)]), Failure<List<int>>(ex));
    });
  });
}
