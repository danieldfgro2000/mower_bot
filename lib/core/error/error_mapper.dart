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
      case 'CONNECTION_FAILED':
        return 'Unable to connect to the mower. Please check your WiFi connection and try again.';
      case 'TIMEOUT':
        return 'Connection timed out. The mower may be out of range or busy.';
      case 'HOST_UNREACHABLE':
        return 'Mower is not reachable. Please verify the IP address and network connection.';
      default:
        return 'Network error: ${exception.message}';
    }
  }

  String _mapWebSocketException(WebSocketException exception) {
    switch (exception.code) {
      case 'CONNECTION_LOST':
        return 'Connection to mower lost. Attempting to reconnect...';
      case 'INVALID_MESSAGE':
        return 'Received invalid data from mower. Please try again.';
      case 'SEND_FAILED':
        return 'Failed to send command to mower. Please check connection.';
      default:
        return 'Communication error: ${exception.message}';
    }
  }

  String _mapValidationException(ValidationException exception) {
    switch (exception.code) {
      case 'REQUIRED_FIELD':
        return exception.message;
      case 'INVALID_FIELD':
        return exception.message;
      default:
        return 'Invalid input: ${exception.message}';
    }
  }

  String _mapDeviceException(DeviceException exception) {
    switch (exception.code) {
      case 'DEVICE_NOT_FOUND':
        return 'Mower not found. Please check if it\'s powered on and connected.';
      case 'COMMUNICATION_FAILED':
        return 'Unable to communicate with mower. Please check the connection.';
      default:
        return 'Device error: ${exception.message}';
    }
  }

  String _mapAuthException(AuthException exception) {
    switch (exception.code) {
      case 'UNAUTHORIZED':
        return 'Access denied. Please check your credentials.';
      case 'FORBIDDEN':
        return 'You don\'t have permission to perform this action.';
      default:
        return 'Authentication error: ${exception.message}';
    }
  }

  String _mapDataException(DataException exception) {
    switch (exception.code) {
      case 'DATA_NOT_FOUND':
        return 'Requested data not found.';
      case 'DATA_CORRUPTED':
        return 'Data appears to be corrupted. Please try refreshing.';
      case 'SERIALIZATION_FAILED':
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
