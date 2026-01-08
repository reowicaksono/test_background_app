import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_background_service/app/app.dart';
import 'package:test_background_service/core/logging/config_logging.dart';
import 'package:test_background_service/firebase_options.dart';
import 'package:test_background_service/firebase_message_services.dart';
import 'package:test_background_service/notifications_services.dart';
import 'package:test_background_service/core/injections/injection_container.dart'
    as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO -> Initialize Environment
  await dotenv.load(fileName: ".env");
  // TODO -> Initialize Dependency Injection
  await di.init();

  // TODO -> Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO -> Initialize Logging App
  LoggingConfig.init();

  // TODO -> Service Notification Messaging
  await NotificationService.instance.init();
  await FirebaseMessagingService.instance.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}
