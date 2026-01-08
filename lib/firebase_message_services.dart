import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:test_background_service/core/injections/injection_container.dart';
import 'package:test_background_service/core/utils/either.dart';
import 'package:test_background_service/features/transaction/domain/usecases/save_fcmtoken_usecase.dart';
import 'package:test_background_service/notifications_services.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final msgService = FirebaseMessaging.instance;

  Future<void> init() async {
    final fcmToken = await msgService.getToken();
    if (fcmToken != null) {
      final result = await sl<SaveFcmtokenUsecase>().call(
        SaveFcmtokenParams(fcmToken: fcmToken),
      );
      result.fold((failure) => Either.left(failure), (_) => Either.right(null));
    }
    NotificationSettings settings = await msgService.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('FCM PERMISSION GRANTED');
    } else {
      debugPrint('FCM PERMISSION DENIED');
    }

    // listen
    FirebaseMessaging.onMessage.listen(handlerMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlerMessage);
  }
}

Future<void> handlerMessage(RemoteMessage message) async {
  debugPrint('FCM MESSAGE: ${message.messageId}');
  debugPrint('FCM DATA: ${message.data}');

  await NotificationService.instance.showNotification(message);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM MESSAGE: ${message.messageId}');
  debugPrint('FCM DATA: ${message.data}');

  await NotificationService.instance.showNotification(message);
}
