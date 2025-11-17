import 'package:flutter/material.dart';
import 'package:mower_bot/core/error/error.dart';

/// Global error notifier for showing errors in UI
class ErrorNotifier extends ChangeNotifier {
  static final ErrorNotifier _instance = ErrorNotifier._internal();
  factory ErrorNotifier() => _instance;
  ErrorNotifier._internal();

  final List<AppException> _errors = [];
  final ErrorMapper _errorMapper = ErrorMapper();

  /// Get current errors
  List<AppException> get errors => List.unmodifiable(_errors);

  /// Add an error to be displayed
  void addError(AppException exception) {
    _errors.add(exception);
    notifyListeners();
  }

  /// Remove an error
  void removeError(AppException exception) {
    _errors.remove(exception);
    notifyListeners();
  }

  /// Clear all errors
  void clearErrors() {
    _errors.clear();
    notifyListeners();
  }

  /// Get user-friendly message for an exception
  String getErrorMessage(AppException exception) {
    return _errorMapper.mapExceptionToMessage(exception);
  }

  /// Get error severity for UI styling
  ErrorSeverity getErrorSeverity(AppException exception) {
    return _errorMapper.getSeverity(exception);
  }
}

/// Extension methods for easy error handling in widgets
extension ErrorHandlingExtensions on BuildContext {
  /// Show an error snackbar
  void showError(AppException exception) {
    final errorNotifier = ErrorNotifier();
    final message = errorNotifier.getErrorMessage(exception);
    final severity = errorNotifier.getErrorSeverity(exception);

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _getColorForSeverity(severity),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(this).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  Color _getColorForSeverity(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Colors.blue;
      case ErrorSeverity.warning:
        return Colors.orange;
      case ErrorSeverity.error:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.red.shade900;
    }
  }
}

/// Error display widget
class ErrorDisplay extends StatelessWidget {
  final AppException exception;
  final VoidCallback? onDismiss;
  final bool showDetails;

  const ErrorDisplay({
    super.key,
    required this.exception,
    this.onDismiss,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final errorNotifier = ErrorNotifier();
    final message = errorNotifier.getErrorMessage(exception);
    final severity = errorNotifier.getErrorSeverity(exception);

    return Card(
      color: _getBackgroundColor(severity),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForSeverity(severity),
                  color: _getIconColor(severity),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _getTextColor(severity),
                    ),
                  ),
                ),
                if (onDismiss != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onDismiss,
                    color: _getIconColor(severity),
                  ),
              ],
            ),
            if (showDetails && exception.code != null) ...[
              const SizedBox(height: 8),
              Text(
                'Error Code: ${exception.code}',
                style: TextStyle(
                  fontSize: 12,
                  color: _getTextColor(severity).withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForSeverity(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Icons.info;
      case ErrorSeverity.warning:
        return Icons.warning;
      case ErrorSeverity.error:
        return Icons.error;
      case ErrorSeverity.critical:
        return Icons.dangerous;
    }
  }

  Color _getBackgroundColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Colors.blue.shade50;
      case ErrorSeverity.warning:
        return Colors.orange.shade50;
      case ErrorSeverity.error:
        return Colors.red.shade50;
      case ErrorSeverity.critical:
        return Colors.red.shade100;
    }
  }

  Color _getIconColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Colors.blue;
      case ErrorSeverity.warning:
        return Colors.orange;
      case ErrorSeverity.error:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.red.shade900;
    }
  }

  Color _getTextColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Colors.blue.shade800;
      case ErrorSeverity.warning:
        return Colors.orange.shade800;
      case ErrorSeverity.error:
        return Colors.red.shade800;
      case ErrorSeverity.critical:
        return Colors.red.shade900;
    }
  }
}
