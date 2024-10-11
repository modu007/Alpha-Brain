import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../main.dart';

class PushNotificationServices {
  static final onClickNotification = BehaviorSubject<Map>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);
    onClickNotification.add(data);
  }

  static localNotificationInitialization() {
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
    notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void saveFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      print(value);
      await SharedFcmToken.setFcmToken(value!);
    });
  }

  static Future firebaseCloudMessaging() async {
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
    bool? isNotificationOn = await SharedFcmToken.getFcmToken("notification");
    if(isNotificationOn == null){
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        SharedFcmToken.setNotification(true);
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print("user granted provisonal permission");
      } else {
        SharedFcmToken.setNotification(false);
      }
    }
  }

  static void showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidDetails =
    const AndroidNotificationDetails(
        "notifications-Ekonara", "Ekonara",
        priority: Priority.max, importance: Importance.max);
    NotificationDetails notiDetails =
    NotificationDetails(android: androidDetails);
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await notificationsPlugin.show(notificationId, message.notification?.title,
        message.notification?.body, notiDetails,
        payload: jsonEncode(message.data));
  }


  static void incomingMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
  }
}