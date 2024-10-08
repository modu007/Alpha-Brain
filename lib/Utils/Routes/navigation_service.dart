import 'package:neuralcode/Utils/Routes/route_name.dart';
import '../../main.dart';

class NavigationService {
  static void navigateToNotificationPost(
      {required String postId, required bool fromBackGround}) {
    navigatorKey.currentState
        ?.restorablePushNamedAndRemoveUntil(
        RouteName.notificationPost, (route) => false,
      arguments:{
          "postId":postId,
        "fromBackground":fromBackGround
      }
    );
  }
}
