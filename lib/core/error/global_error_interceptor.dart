import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/error/error.dart';

/// Global error interceptor that catches unhandled exceptions
class GlobalErrorInterceptor {
  static final GlobalErrorInterceptor _instance = GlobalErrorInterceptor._internal();
  factory GlobalErrorInterceptor() => _instance;
  GlobalErrorInterceptor._internal();

  final ExceptionHandler _exceptionHandler = ExceptionHandler();
  final ErrorNotifier _errorNotifier = ErrorNotifier();

  StreamSubscription? _errorSubscription;
  bool _isInitialized = false;

  /// Initialize global error handling
  void initialize() {
    if (_isInitialized) return;

    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      final exception = _exceptionHandler.handleException(
        details.exception,
        details.stack,
      );
      _errorNotifier.addError(exception);

      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // Handle async errors not caught by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      final exception = _exceptionHandler.handleException(error, stack);
      _errorNotifier.addError(exception);
      return true;
    };

    // Listen to exception handler stream for additional processing
    _errorSubscription = _exceptionHandler.exceptions.listen(
      (exception) => _errorNotifier.addError(exception),
    );

    _isInitialized = true;

    if (kDebugMode) {
      print('🛡️ Global error interceptor initialized');
    }
  }

  /// Dispose resources
  void dispose() {
    _errorSubscription?.cancel();
    _exceptionHandler.dispose();
    _isInitialized = false;
  }

  /// Manually report an exception
  void reportException(AppException exception) {
    _exceptionHandler.reportException(exception);
  }

  /// Check if interceptor is initialized
  bool get isInitialized => _isInitialized;
}

/// Mixin for classes that need error handling capabilities
mixin ErrorHandlingMixin {
  final ExceptionHandler _exceptionHandler = ExceptionHandler();
  final ErrorMapper _errorMapper = ErrorMapper();

  /// Handle an exception and return user-friendly message
  String handleError(dynamic error, [StackTrace? stackTrace]) {
    final appException = _exceptionHandler.handleException(error, stackTrace);
    return _errorMapper.mapExceptionToMessage(appException);
  }

  /// Safe execution with error handling
  Future<T?> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    T? defaultValue,
    Function(AppException)? onError,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final appException = _exceptionHandler.handleException(error, stackTrace);
      onError?.call(appException);
      return defaultValue;
    }
  }

  /// Safe synchronous execution
  T? executeSyncWithErrorHandling<T>(
    T Function() operation, {
    T? defaultValue,
    Function(AppException)? onError,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      final appException = _exceptionHandler.handleException(error, stackTrace);
      onError?.call(appException);
      return defaultValue;
    }
  }

  /// Dispose error handling resources
  void disposeErrorHandling() {
    _exceptionHandler.dispose();
  }
}
