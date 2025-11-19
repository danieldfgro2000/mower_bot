import 'package:flutter/foundation.dart';
import 'package:mower_bot/core/error/app_exception.dart';

/// A result wrapper that encapsulates success or failure states
sealed class Result<T> {
  const Result();

  /// Check if the result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the success data (throws if failure)
  T get data {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    throw StateError('Attempted to get data from a failure result');
  }

  /// Get the failure exception (throws if success)
  AppException get exception {
    if (this is Failure<T>) {
      return (this as Failure<T>).exception;
    }
    throw StateError('Attempted to get exception from a success result');
  }

  /// Get data or null if failure
  T? get dataOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Get exception or null if success
  AppException? get exceptionOrNull {
    if (this is Failure<T>) {
      return (this as Failure<T>).exception;
    }
    return null;
  }

  /// Transform the data if successful, preserve failure
  Result<R> map<R>(R Function(T data) transform) {
    if (this is Success<T>) {
      try {
        return Success(transform((this as Success<T>).data));
      } catch (error, stackTrace) {
        return Failure(GenericException(
          message: 'Transformation failed: $error',
          code: 'TRANSFORM_ERROR',
          originalError: error,
          stackTrace: stackTrace,
        ));
      }
    }
    return Failure((this as Failure<T>).exception);
  }

  /// Transform the data asynchronously if successful
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) transform) async {
    if (this is Success<T>) {
      try {
        final result = await transform((this as Success<T>).data);
        return Success(result);
      } catch (error, stackTrace) {
        return Failure(GenericException(
          message: 'Async transformation failed: $error',
          code: 'ASYNC_TRANSFORM_ERROR',
          originalError: error,
          stackTrace: stackTrace,
        ));
      }
    }
    return Failure((this as Failure<T>).exception);
  }

  /// Execute a function on success, ignore on failure
  Result<T> onSuccess(void Function(T data) action) {
    if (this is Success<T>) {
      try {
        action((this as Success<T>).data);
      } catch (error, stackTrace) {
        return Failure(GenericException(
          message: 'Success callback failed: $error',
          code: 'SUCCESS_CALLBACK_ERROR',
          originalError: error,
          stackTrace: stackTrace,
        ));
      }
    }
    return this;
  }

  /// Execute a function on failure, ignore on success
  Result<T> onFailure(void Function(AppException exception) action) {
    if (this is Failure<T>) {
      try {
        action((this as Failure<T>).exception);
      } catch (error, _) {
        // Log the callback error but don't change the original failure
        if (kDebugMode) {
          print('Failure callback error: $error');
        }
      }
    }
    return this;
  }

  /// Fold the result into a single value
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AppException exception) onFailure,
  ) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    }
    return onFailure((this as Failure<T>).exception);
  }
}

/// Success result containing data
class Success<T> extends Result<T> {
  @override
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Failure result containing an exception
class Failure<T> extends Result<T> {
  @override
  final AppException exception;

  const Failure(this.exception);

  @override
  String toString() => 'Failure(${exception.message})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && runtimeType == other.runtimeType && exception == other.exception;

  @override
  int get hashCode => exception.hashCode;
}

/// Extension methods for easier Result creation
extension ResultExtensions<T> on T {
  /// Wrap this value in a Success result
  Result<T> toSuccess() => Success(this);
}

extension ExceptionResultExtensions on AppException {
  /// Wrap this exception in a Failure result
  Result<T> toFailure<T>() => Failure<T>(this);
}

/// Utility functions for Result
class ResultUtils {
  /// Create a Success result
  static Result<T> success<T>(T data) => Success(data);

  /// Create a Failure result
  static Result<T> failure<T>(AppException exception) => Failure(exception);

  /// Execute an operation and wrap the result
  static Result<T> execute<T>(T Function() operation) {
    try {
      return Success(operation());
    } catch (error, stackTrace) {
      final exception = error is AppException
          ? error
          : GenericException.unknown(error, stackTrace);
      return Failure(exception);
    }
  }

  /// Execute an async operation and wrap the result
  static Future<Result<T>> executeAsync<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return Success(result);
    } catch (error, stackTrace) {
      final exception = error is AppException
          ? error
          : GenericException.unknown(error, stackTrace);
      return Failure(exception);
    }
  }

  /// Combine multiple Results into one
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final List<T> successValues = [];

    for (final result in results) {
      if (result.isFailure) {
        return Failure(result.exception);
      }
      successValues.add(result.data);
    }

    return Success(successValues);
  }
}
