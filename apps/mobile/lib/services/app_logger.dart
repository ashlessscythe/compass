import 'package:flutter/foundation.dart';

/// Thin logging facade. Swap the sink later without touching call sites.
abstract interface class AppLogger {
  void debug(String message, {Object? error, StackTrace? stackTrace});

  void info(String message);

  void warning(String message, {Object? error, StackTrace? stackTrace});

  void error(String message, {Object? error, StackTrace? stackTrace});
}

/// Debug-console implementation suitable for local development.
class ConsoleAppLogger implements AppLogger {
  const ConsoleAppLogger();

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
      if (error != null) debugPrint('  error: $error');
    }
  }

  @override
  void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    debugPrint('[WARN] $message');
    if (error != null) debugPrint('  error: $error');
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('  error: $error');
    if (stackTrace != null) debugPrint('$stackTrace');
  }
}
