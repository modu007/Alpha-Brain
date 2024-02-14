import 'package:flutter/material.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:neuralcode/View/Auth/register.dart';
import 'package:neuralcode/View/Home/home.dart';
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
