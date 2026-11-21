import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  static void debug(String message, {String? tag, Object? data}) =>
      _log(LogLevel.debug, message, tag: tag, data: data);

  static void info(String message, {String? tag, Object? data}) =>
      _log(LogLevel.info, message, tag: tag, data: data);

  static void warning(String message,
          {String? tag, Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.warning, message,
          tag: tag, error: error, stackTrace: stackTrace);

  static void error(String message,
          {String? tag, Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.error, message,
          tag: tag, error: error, stackTrace: stackTrace);

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode && level == LogLevel.debug) return;

    final prefix = switch (level) {
      LogLevel.debug => '🔍 DEBUG',
      LogLevel.info => 'ℹ️  INFO',
      LogLevel.warning => '⚠️  WARN',
      LogLevel.error => '🔴 ERROR',
    };

    final tagStr = tag != null ? ' [$tag]' : '';
    final dataStr = data != null ? '\n  data: $data' : '';
    final errStr = error != null ? '\n  error: $error' : '';

    // ignore: avoid_print
    print('$prefix$tagStr: $message$dataStr$errStr');

    if (stackTrace != null && level == LogLevel.error) {
      // ignore: avoid_print
      print('  stackTrace: $stackTrace');
    }
  }
}
