import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_background_service/app/app.dart';
import 'package:test_background_service/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO -> Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}
