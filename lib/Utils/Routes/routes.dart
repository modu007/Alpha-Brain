import 'package:flutter/material.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:neuralcode/View/Auth/otp_verification.dart';
import 'package:neuralcode/View/Auth/register.dart';
import 'package:neuralcode/View/Auth/sign_in.dart';
import 'package:neuralcode/View/Home/home.dart';
import 'package:neuralcode/View/Profile/edit_profile.dart';
import 'package:neuralcode/View/Profile/profile.dart';
import 'package:neuralcode/View/Splash/splash.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Home());
        case RouteName.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Register());
        case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
        case RouteName.signIn:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignIn());
        case RouteName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Profile());
        case RouteName.editProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const EditProfile());
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
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
