import 'package:flutter/material.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:neuralcode/View/Auth/otp_verification.dart';
import 'package:neuralcode/View/Auth/register.dart';
import 'package:neuralcode/View/Auth/sign.dart';
import 'package:neuralcode/View/Auth/sign_in.dart';
import 'package:neuralcode/View/Home/home.dart';
import 'package:neuralcode/View/Interests/intrests.dart';
import 'package:neuralcode/View/NotificationPost/notification_post.dart';
import 'package:neuralcode/View/Profile/edit_profile.dart';
import 'package:neuralcode/View/Profile/profile.dart';
import 'package:neuralcode/View/Splash/splash.dart';
import 'package:neuralcode/View/SupportScreen/support_screen.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
appUpdate()async{
  const url = 'https://play.google.com/store/apps/details?id=com.ai.neuralcode&hl=en';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;
    print("Handling route: ${settings.name}");
    print("Arguments passed: ${settings.arguments}");
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => UpgradeAlert(
                showLater: false,
                showIgnore: false,
                // upgrader: Upgrader(
                //     debugDisplayAlways: true,
                //     minAppVersion: "1.1.12+20"
                // ),
                onUpdate: (){
                  print("here");
                  appUpdate();
                  return true;
                },
                child: const Home()));
        case RouteName.support:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SupportScreen());
        case RouteName.register:
        if(argument is Map){
          return MaterialPageRoute(
              builder: (BuildContext context) =>  Register(
                emailId: argument["emailId"],
                isGoogleSignIn: argument["isGoogleSignIn"] ?? false,
              ));
        }else{
          return MaterialPageRoute(
              builder: (BuildContext context) => const Register());
        }
        case RouteName.splash:
        if(argument is Map){
          return MaterialPageRoute(
              builder: (BuildContext context) =>  SplashScreen(
                fromBackGround: argument["fromBackground"],
                postId: argument["postId"],
              ));
        }else{
          return MaterialPageRoute(
              builder: (BuildContext context) => const SplashScreen(
                postId: null,
                fromBackGround: null,
              ));
        }
        case RouteName.signIn:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Sign());
      case RouteName.signInAlreadyHaveAnAccount:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignIn());
        case RouteName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Profile());
        case RouteName.notificationPost:
       if(argument is Map){
         return MaterialPageRoute(
             builder: (BuildContext context) =>  NotificationPost(postId: argument["postId"],)
         );
       }else{
         return MaterialPageRoute(builder: (_) {
           return const Scaffold(
             body: Center(
               child: Text('No route defined ko'),
             ),
           );
         });
       }
        case RouteName.editProfile:
        if(argument is Map){
          return MaterialPageRoute(
              builder: (BuildContext context) => EditProfile(
                name: argument["name"],
                dob: argument["dob"],
                gender: argument["gender"],
              ));
        }else{
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
        }
      case RouteName.interests:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Interests());
        case RouteName.otpVerification:
          if(argument is Map){
            return MaterialPageRoute(
                builder: (BuildContext context) =>  OtpVerification(
                  email: argument["email"],
                ));
          }else{
            return MaterialPageRoute(builder: (_) {
              return const Scaffold(
                body: Center(
                  child: Text('No route defined'),
                ),
              );
            });
          }
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route definedDD'),
            ),
          );
        });
    }
  }
}
