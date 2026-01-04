import 'dart:developer' as dev;
import 'package:test_background_service/app/logger/enum_logger.dart';

class AppLogger {
  const AppLogger._();

  static bool enable = true;

  static void log(
    String message, {
    LogLevel level = LogLevel.debug,
    Object? error,
    StackTrace? stackTrace,
    String tag = 'App',
  }) {
    if (!enable) return;
    dev.log(
      message,
      name: tag,
      level: _mapLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
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
