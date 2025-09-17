/// Base exception class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.connectionFailed(String host, int port, [dynamic error]) {
    return NetworkException(
      message: 'Failed to connect to $host:$port',
      code: 'CONNECTION_FAILED',
      originalError: error,
    );
  }

  factory NetworkException.timeout(String operation, [dynamic error]) {
    return NetworkException(
      message: 'Operation timed out: $operation',
      code: 'TIMEOUT',
      originalError: error,
    );
  }

  factory NetworkException.hostUnreachable(String host, [dynamic error]) {
    return NetworkException(
      message: 'Host unreachable: $host',
      code: 'HOST_UNREACHABLE',
      originalError: error,
    );
  }
}

/// WebSocket related exceptions
class WebSocketException extends AppException {
  const WebSocketException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory WebSocketException.connectionLost([dynamic error]) {
    return WebSocketException(
      message: 'WebSocket connection lost',
      code: 'CONNECTION_LOST',
      originalError: error,
    );
  }

  factory WebSocketException.invalidMessage(String reason, [dynamic error]) {
    return WebSocketException(
      message: 'Invalid WebSocket message: $reason',
      code: 'INVALID_MESSAGE',
      originalError: error,
    );
  }

  factory WebSocketException.sendFailed(String reason, [dynamic error]) {
    return WebSocketException(
      message: 'Failed to send WebSocket message: $reason',
      code: 'SEND_FAILED',
      originalError: error,
    );
  }
}

/// Validation related exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.required(String fieldName) {
    return ValidationException(
      message: '$fieldName is required',
      code: 'REQUIRED_FIELD',
      fieldErrors: {fieldName: 'This field is required'},
    );
  }

  factory ValidationException.invalid(String fieldName, String reason) {
    return ValidationException(
      message: 'Invalid $fieldName: $reason',
      code: 'INVALID_FIELD',
      fieldErrors: {fieldName: reason},
    );
  }
}

/// Device/Hardware related exceptions
class DeviceException extends AppException {
  const DeviceException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory DeviceException.notFound(String deviceType) {
    return DeviceException(
      message: '$deviceType not found',
      code: 'DEVICE_NOT_FOUND',
    );
  }

  factory DeviceException.communicationFailed(String deviceType, [dynamic error]) {
    return DeviceException(
      message: 'Communication failed with $deviceType',
      code: 'COMMUNICATION_FAILED',
      originalError: error,
    );
  }
}

/// Authentication/Authorization exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.unauthorized() {
    return const AuthException(
      message: 'Unauthorized access',
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthException.forbidden() {
    return const AuthException(
      message: 'Access forbidden',
      code: 'FORBIDDEN',
    );
  }
}

/// Data/State related exceptions
class DataException extends AppException {
  const DataException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory DataException.notFound(String resource) {
    return DataException(
      message: '$resource not found',
      code: 'DATA_NOT_FOUND',
    );
  }

  factory DataException.corrupted(String resource, [dynamic error]) {
    return DataException(
      message: 'Data corrupted: $resource',
      code: 'DATA_CORRUPTED',
      originalError: error,
    );
  }

  factory DataException.serializationFailed(String operation, [dynamic error]) {
    return DataException(
      message: 'Serialization failed: $operation',
      code: 'SERIALIZATION_FAILED',
      originalError: error,
    );
  }
}

/// Generic application exception for unknown errors
class GenericException extends AppException {
  const GenericException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory GenericException.unknown(dynamic error, [StackTrace? stackTrace]) {
    return GenericException(
      message: error.toString(),
      code: 'UNKNOWN_ERROR',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}
