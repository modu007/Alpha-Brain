import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import '../../Utils/Routes/route_name.dart';
import '../../main.dart';

class NotificationController {
  /// Method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Logic for notification creation
    print("Notification created: ${receivedNotification.title}");
  }

  /// Method to detect every time a notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Logic for notification display
    print("Notification displayed: ${receivedNotification.title}");
  }

  /// Method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Logic for notification dismissal
    print("Notification dismissed: ${receivedAction.id}");
  }

  /// Method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    print("Notification action received: ${receivedAction.id}");
    print(receivedAction.payload);
    if (receivedAction.payload != null) {
      if (receivedAction.payload!.containsKey("data")) {
        Map<String, dynamic> data = jsonDecode(receivedAction.payload!["data"]!);
        if (data["post_id"] != null) {
          String postId = data["post_id"];
          navigatorKey.currentState?.restorablePushNamed(
            RouteName.notificationPost,
            arguments: {
              "postId": postId,
              "fromBackground": false,
            },
          );
        } else {
          print("No post_id found in the data.");
        }
      } else {
        print("No 'data' field found in the payload.");
      }
    }
    else {
      print("No post_id found in the notification payload.");
    }
  }
}
