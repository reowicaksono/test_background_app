import 'package:flutter/foundation.dart';
import 'package:test_background_service/app/logger/app_logger.dart';

class LoggingConfig {
  static void init() {
    if (kReleaseMode) {
      AppLogger.enable = false;
    } else if (kProfileMode) {
      AppLogger.enable = true;
    } else {
      AppLogger.enable = true;
    }
  }
}
