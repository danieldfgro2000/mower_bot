import 'package:mower_bot/core/error/app_exception.dart';

/// Maps exceptions to user-friendly error messages
class ErrorMapper {
  static final ErrorMapper _instance = ErrorMapper._internal();
  factory ErrorMapper() => _instance;
  ErrorMapper._internal();

  /// Convert an exception to a user-friendly message
  String mapExceptionToMessage(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException _:
        return _mapNetworkException(exception as NetworkException);
      case WebSocketException _:
        return _mapWebSocketException(exception as WebSocketException);
      case ValidationException _:
        return _mapValidationException(exception as ValidationException);
      case DeviceException _:
        return _mapDeviceException(exception as DeviceException);
      case AuthException _:
        return _mapAuthException(exception as AuthException);
      case DataException _:
        return _mapDataException(exception as DataException);
      default:
        return exception.message;
    }
  }

  String _mapNetworkException(NetworkException exception) {
    switch (exception.code) {
      case AppExceptionCode.connectionFailed:
        return 'Unable to connect to the mower. Please check your WiFi connection and try again.';
      case AppExceptionCode.timeout:
        return 'Connection timed out. The mower may be out of range or busy.';
      case AppExceptionCode.hostUnreachable:
        return 'Mower is not reachable. Please verify the IP address and network connection.';
      default:
        return 'Network error: ${exception.message}';
    }
  }

  String _mapWebSocketException(WebSocketException exception) {
    switch (exception.code) {
      case AppExceptionCode.connectionLost:
        return 'Connection to mower lost. Attempting to reconnect...';
      case AppExceptionCode.invalidMessage:
        return 'Received invalid data from mower. Please try again.';
      case AppExceptionCode.sendFailed:
        return 'Failed to send command to mower. Please check connection.';
      default:
        return 'Communication error: ${exception.message}';
    }
  }

  String _mapValidationException(ValidationException exception) {
    switch (exception.code) {
      case AppExceptionCode.requiredField:
        return exception.message;
      case AppExceptionCode.invalidField:
        return exception.message;
      default:
        return 'Invalid input: ${exception.message}';
    }
  }

  String _mapDeviceException(DeviceException exception) {
    switch (exception.code) {
      case AppExceptionCode.deviceNotFound:
        return 'Mower not found. Please check if it\'s powered on and connected.';
      case AppExceptionCode.communicationFailed:
        return 'Unable to communicate with mower. Please check the connection.';
      default:
        return 'Device error: ${exception.message}';
    }
  }

  String _mapAuthException(AuthException exception) {
    switch (exception.code) {
      case AppExceptionCode.unauthorized:
        return 'Access denied. Please check your credentials.';
      case AppExceptionCode.forbidden:
        return 'You don\'t have permission to perform this action.';
      default:
        return 'Authentication error: ${exception.message}';
    }
  }

  String _mapDataException(DataException exception) {
    switch (exception.code) {
      case AppExceptionCode.dataNotFound:
        return 'Requested data not found.';
      case AppExceptionCode.dataCorrupted:
        return 'Data appears to be corrupted. Please try refreshing.';
      case AppExceptionCode.serializationFailed:
        return 'Failed to process data. Please try again.';
      default:
        return 'Data error: ${exception.message}';
    }
  }

  /// Get a severity level for the exception (for UI styling)
  ErrorSeverity getSeverity(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException _:
      case WebSocketException _:
        return ErrorSeverity.warning;
      case ValidationException _:
        return ErrorSeverity.info;
      case DeviceException _:
      case AuthException _:
        return ErrorSeverity.error;
      case DataException _:
        return ErrorSeverity.warning;
      default:
        return ErrorSeverity.error;
    }
  }
}

/// Error severity levels for UI representation
enum ErrorSeverity {
  info,
  warning,
  error,
  critical,
}
