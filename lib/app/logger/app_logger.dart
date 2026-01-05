import 'dart:convert';
import 'dart:developer' as dev;
import 'package:test_background_service/app/logger/enum_logger.dart';

class AppLogger {
  const AppLogger._();

  static bool enable = true;

  static void log(
    String message, {
    LogLevel level = LogLevel.debug,
    Object? error,
    Object? data,
    StackTrace? stackTrace,
    String tag = 'App',
  }) {
    if (!enable) return;
    final formatedMessage = data != null
        ? '$message | data: ${_stringifyData(data)}'
        : message;
    dev.log(
      formatedMessage,
      name: tag,
      level: _mapLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String _stringifyData(Object data) {
    try {
      if (data is Map || data is List) {
        return jsonEncode(data);
      }
      return data.toString();
    } catch (_) {
      return data.toString();
    }
  }

  static int _mapLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.fatal:
        return 1200;
    }
  }
}
