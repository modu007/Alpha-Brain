import 'package:neuralcode/Utils/Routes/route_name.dart';
import '../../main.dart';

class NavigationService {
  static void navigateToNotificationPost(String postId) {
    print("ll");
    navigatorKey.currentState
        ?.restorablePushNamedAndRemoveUntil(
        RouteName.notificationPost, (route) => false,
      arguments:{
          "postId":postId
      }
    );
  }
}
