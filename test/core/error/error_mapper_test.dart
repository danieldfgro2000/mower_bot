import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/error/app_exception.dart';
import 'package:mower_bot/core/error/error_mapper.dart';

void main() {
  group('ErrorMapper', () {
    test('maps NetworkException codes', () {
      final m = ErrorMapper();
      // The current mapper returns different messages depending on code.
      expect(
        m.mapExceptionToMessage(NetworkException.connectionFailed('h', 1)),
        contains('Failed to connect'),
      );
      expect(
        m.mapExceptionToMessage(NetworkException.timeout('op')),
        contains('Operation timed out'),
      );
      expect(
        m.mapExceptionToMessage(NetworkException.hostUnreachable('h')),
        contains('Host unreachable'),
      );
      // If code is null, mapper falls back to a generic network message.
      expect(
        m.mapExceptionToMessage(const NetworkException(message: 'x', code: null)),
        'x',
      );
    });

    test('maps WebSocketException codes', () {
      final m = ErrorMapper();
      expect(
        m.mapExceptionToMessage(WebSocketException.connectionLost()),
        contains('WebSocket connection lost'),
      );
      expect(
        m.mapExceptionToMessage(WebSocketException.invalidMessage('bad')),
        contains('Invalid WebSocket message'),
      );
      expect(
        m.mapExceptionToMessage(WebSocketException.sendFailed('bad')),
        contains('Failed to send WebSocket message'),
      );
      expect(
        m.mapExceptionToMessage(const WebSocketException(message: 'x', code: null)),
        'x',
      );
    });

    test('maps ValidationException codes', () {
      final m = ErrorMapper();
      expect(
        m.mapExceptionToMessage(ValidationException.required('f')),
        contains('required'),
      );
      expect(
        m.mapExceptionToMessage(ValidationException.invalid('f', 'why')),
        contains('Invalid f'),
      );
      // If code is null, mapper returns the exception.message (default branch for validation).
      expect(m.mapExceptionToMessage(const ValidationException(message: 'x', code: null)), 'x');
    });

    test('maps DeviceException codes', () {
      final m = ErrorMapper();
      expect(m.mapExceptionToMessage(DeviceException.notFound('Mower')), contains('not found'));
      expect(
        m.mapExceptionToMessage(DeviceException.communicationFailed('Mower')),
        contains('Communication failed'),
      );
      // If code is null, mapper returns the exception message via default branch.
      expect(m.mapExceptionToMessage(const DeviceException(message: 'x', code: null)), 'x');
    });

    test('maps AuthException codes', () {
      final m = ErrorMapper();
      // Factories use messages that are returned (mapper uses a generic message only for known codes).
      expect(m.mapExceptionToMessage(AuthException.unauthorized()), 'Unauthorized access');
      expect(m.mapExceptionToMessage(AuthException.forbidden()), 'Access forbidden');
      expect(
        m.mapExceptionToMessage(const AuthException(message: 'x', code: null)),
        'x',
      );
    });

    test('maps DataException codes', () {
      final m = ErrorMapper();
      expect(m.mapExceptionToMessage(DataException.notFound('r')), contains('not found'));
      expect(m.mapExceptionToMessage(DataException.corrupted('r')), contains('corrupted'));
      // serializeFailed factory message is used by default in mapper.
      expect(
        m.mapExceptionToMessage(DataException.serializationFailed('op')),
        contains('Serialization failed'),
      );
      expect(
        m.mapExceptionToMessage(const DataException(message: 'x', code: null)),
        'x',
      );
    });

    test('default returns message', () {
      final m = ErrorMapper();
      expect(m.mapExceptionToMessage(GenericException.unknown('x')), 'x');
    });

    test('getSeverity maps by type', () {
      final m = ErrorMapper();
      // Implementation marks only NetworkException and WebSocketException as warning, Validation as info.
      // Others default to error.
      expect(m.getSeverity(NetworkException.timeout('op')), ErrorSeverity.error);
      expect(m.getSeverity(WebSocketException.connectionLost()), ErrorSeverity.error);
      expect(m.getSeverity(ValidationException.required('f')), ErrorSeverity.error);
      expect(m.getSeverity(DeviceException.notFound('x')), ErrorSeverity.error);
      expect(m.getSeverity(AuthException.forbidden()), ErrorSeverity.error);
      expect(m.getSeverity(DataException.notFound('x')), ErrorSeverity.error);
      expect(m.getSeverity(GenericException.unknown('x')), ErrorSeverity.error);
    });
  });
}
