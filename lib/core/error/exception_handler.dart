import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/error/app_exception.dart';

/// Global exception handler for the application
class ExceptionHandler {
  static final ExceptionHandler _instance = ExceptionHandler._internal();
  factory ExceptionHandler() => _instance;
  ExceptionHandler._internal();

  StreamController<AppException> _exceptionController =
      StreamController<AppException>.broadcast();

  /// Stream of unhandled exceptions
  Stream<AppException> get exceptions {
    // If someone disposed the handler and later uses it again (common in tests
    // because this is a singleton), recreate the controller.
    if (_exceptionController.isClosed) {
      _exceptionController = StreamController<AppException>.broadcast();
    }
    return _exceptionController.stream;
  }

  /// Handle and convert generic exceptions to AppExceptions
  AppException handleException(dynamic error, [StackTrace? stackTrace]) {
    AppException appException;

    // Use type checks rather than runtimeType switching; subclasses and
    // different exception implementations should still be recognized.
    if (error is SocketException) {
      appException = NetworkException.connectionFailed(
        error.address?.host ?? 'unknown',
        error.port ?? 0,
        error,
      );
    } else if (error is TimeoutException) {
      appException = NetworkException.timeout(
        'Network operation',
        error,
      );
    } else if (error is FormatException) {
      appException = DataException.serializationFailed(
        'Data parsing',
        error,
      );
    } else if (error is StateError) {
      appException = DataException(
        message: 'Invalid state: ${error.message}',
        code: AppExceptionCode.invalidField,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is ArgumentError) {
      appException = ValidationException(
        message: 'Invalid argument: ${error.message}',
        code: AppExceptionCode.invalidField,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is AppException) {
      appException = error;
    } else {
      appException = GenericException.unknown(error, stackTrace);
    }

    _reportException(appException);
    return appException;
  }

  /// Report exception to the stream and logging
  void _reportException(AppException exception) {
    if (kDebugMode) {
      print('🚨 Exception: ${exception.message}');
      if (exception.code != null) {
        print('   Code: ${exception.code}');
      }
      if (exception.originalError != null) {
        print('   Original: ${exception.originalError}');
      }
      if (exception.stackTrace != null) {
        print('   Stack: ${exception.stackTrace}');
      }
    }

    if (_exceptionController.isClosed) {
      // Avoid throwing in release / tests. Recreate so future listeners work.
      _exceptionController = StreamController<AppException>.broadcast();
    }
    _exceptionController.add(exception);
  }

  /// Manually report an exception
  void reportException(AppException exception) {
    _reportException(exception);
  }

  /// Safe execution wrapper that catches and handles exceptions
  Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    T? defaultValue,
    bool suppressError = false,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final appException = handleException(error, stackTrace);

      if (!suppressError) {
        throw appException;
      }

      return defaultValue;
    }
  }

  /// Safe execution wrapper for synchronous operations
  T? safeExecuteSync<T>(
    T Function() operation, {
    T? defaultValue,
    bool suppressError = false,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      final appException = handleException(error, stackTrace);

      if (!suppressError) {
        throw appException;
      }

      return defaultValue;
    }
  }

  /// Dispose resources
  void dispose() {
    _exceptionController.close();
  }
}

/// Extension for easy exception handling
extension ExceptionHandling on Future {
  /// Handle exceptions and convert to AppException
  Future<T> handleExceptions<T>() async {
    try {
      return await this as T;
    } catch (error, stackTrace) {
      throw ExceptionHandler().handleException(error, stackTrace);
    }
  }

  /// Safe execution with default value on error
  Future<T?> safely<T>({T? defaultValue}) async {
    return ExceptionHandler().safeExecute<T>(
      () async => await this as T,
      defaultValue: defaultValue,
      suppressError: true,
    );
  }
}
