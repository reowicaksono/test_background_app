import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  const EnvironmentConfig._();

  static String get baseUrl => dotenv.env["API_BASE_URL"] ?? "";
  static String get apiKey => dotenv.env["API_KEY"] ?? "";
  static String get fcmToken => dotenv.env["FCM_TOKEN"] ?? "";
}
