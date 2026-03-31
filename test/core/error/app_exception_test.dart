import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/error/app_exception.dart';

void main() {
  group('AppException types', () {
    test('toString includes code when present', () {
      const ex = NetworkException(message: 'm', code: AppExceptionCode.timeout);
      expect(ex.toString(), contains('AppException: m'));
      expect(ex.toString(), contains('Code:'));
    });

    test('NetworkException factories', () {
      final ex1 = NetworkException.connectionFailed('h', 1);
      expect(ex1.code, AppExceptionCode.connectionFailed);
      expect(ex1.message, contains('h:1'));

      final ex2 = NetworkException.timeout('op');
      expect(ex2.code, AppExceptionCode.timeout);

      final ex3 = NetworkException.hostUnreachable('h');
      expect(ex3.code, AppExceptionCode.hostUnreachable);
    });

    test('WebSocketException factories', () {
      final ex1 = WebSocketException.connectionLost();
      expect(ex1.code, AppExceptionCode.connectionLost);

      final ex2 = WebSocketException.invalidMessage('why');
      expect(ex2.code, AppExceptionCode.invalidMessage);
      expect(ex2.message, contains('why'));

      final ex3 = WebSocketException.sendFailed('why');
      expect(ex3.code, AppExceptionCode.sendFailed);
    });

    test('ValidationException factories and fieldErrors', () {
      final ex1 = ValidationException.required('f');
      expect(ex1.code, AppExceptionCode.requiredField);
      expect(ex1.fieldErrors, contains('f'));

      final ex2 = ValidationException.invalid('f', 'why');
      expect(ex2.code, AppExceptionCode.invalidField);
      expect(ex2.fieldErrors, {'f': 'why'});
    });

    test('DeviceException factories', () {
      final ex1 = DeviceException.notFound('Mower');
      expect(ex1.code, AppExceptionCode.deviceNotFound);

      final ex2 = DeviceException.communicationFailed('Mower');
      expect(ex2.code, AppExceptionCode.deviceNotFound);
    });

    test('AuthException factories', () {
      final ex1 = AuthException.unauthorized();
      expect(ex1.code, AppExceptionCode.unauthorized);

      final ex2 = AuthException.forbidden();
      expect(ex2.code, AppExceptionCode.forbidden);
    });

    test('DataException factories', () {
      final ex1 = DataException.notFound('r');
      expect(ex1.code, AppExceptionCode.dataNotFound);

      final ex2 = DataException.corrupted('r');
      expect(ex2.code, AppExceptionCode.dataCorrupted);

      final ex3 = DataException.serializationFailed('op');
      expect(ex3.code, AppExceptionCode.serializationFailed);
    });

    test('GenericException.unknown uses error.toString and unknownError code', () {
      final ex = GenericException.unknown(StateError('x'));
      expect(ex.code, AppExceptionCode.unknownError);
      expect(ex.message, contains('Bad state'));
    });
  });
}

