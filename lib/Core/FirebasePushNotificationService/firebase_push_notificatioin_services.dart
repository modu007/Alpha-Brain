import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../main.dart';

class PushNotificationServices {
  static InitializationSettings localNotificationInitialization() {
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings iosSettings =
        const DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestCriticalPermission: true,
            requestSoundPermission: true);
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    return initializationSettings;
  }

  static void saveFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      await SharedFcmToken.setFcmToken(value!);
    });
  }

  static void firebaseCloudMessaging() async {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisonal permission");
    } else {
      print("user declined or not granted permission");
    }
  }

  static void showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
            "notifications-youtube", "YouTube Notifications",
            priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await notificationsPlugin.show(
        0, message.notification?.title, message.notification?.body, notiDetails,
        payload: message.data["title"]);
  }

  static void incomingMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("on message ${message.data}data\n ${message.notification?.title}"
          " title\n ${message.notification?.body} body \n");
      showNotification(message);
    });
  }
}
