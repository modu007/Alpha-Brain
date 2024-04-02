import 'package:flutter/material.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:neuralcode/View/Auth/otp_verification.dart';
import 'package:neuralcode/View/Auth/register.dart';
import 'package:neuralcode/View/Auth/sign_in.dart';
import 'package:neuralcode/View/Home/home.dart';
import 'package:neuralcode/View/NotificationPost/notification_post.dart';
import 'package:neuralcode/View/Profile/edit_profile.dart';
import 'package:neuralcode/View/Profile/profile.dart';
import 'package:neuralcode/View/Splash/splash.dart';
import 'package:neuralcode/View/SupportScreen/support_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Home());
        case RouteName.support:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SupportScreen());
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
        case RouteName.notificationPost:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  NotificationPost(
              postData:ForYouModel(
                id: "66017aada3496777eabbe676",
                dateTime: "Mon, 25 Mar 2024 18:52:53 GMT",
                imageUrl: "https://www.hindustantimes.com/ht-img/img/2024/03/25/550x309/2021-02-10T111521Z_483092492_RC2NPL98VC3S_RTRMADP__1711342172612_1711342172798.JPG",
                myBookmark: [],
                myEmojis: [],
                newsUrl: "https://www.hindustantimes.com/business/coke-pepsi-using-child-labour-in-maharashtra-forced-hysterectomies-and-child-marriages-report-101711339403736.html",
                source: "hindustan times",
                summary: Summary(
                  title: "Coke and Pepsi Accused of Profiting from Exploitative Labor Practices",
                  keyPoints: [
                    KeyPoint(
                      subHeading: "Child Labor and Forced Sterilization:",
                      description: "A New York Times and Fuller Project investigation revealed that Coke and Pepsi have profited from a system that exploits children in sugar cane fields, with reports of girls being pushed into child marriages to work in sugarcane fields and undergo unnecessary sterilization procedures.",
                    ),
                    KeyPoint(
                      subHeading: "Impact on Women's Health:",
                      description: "The report highlighted the lasting impact on women's health due to the forced hysterectomies, including abdominal pain, blood clots, early menopause, heart disease, osteoporosis, and other ailments. The working conditions for sugar laborers have been defined as forced labor by workers' rights groups and the United Nations labor agency.",
                    ),
                    KeyPoint(
                      subHeading: "Company Responses:",
                      description: "While Coca-Cola has not directly responded to the report, it was noted that the company had earlier reported supporting a program to gradually reduce child labor in India. PepsiCo expressed deep concern over the working conditions and committed to conducting an assessment of sugar-cane cutter working conditions and taking necessary actions through franchisee partners.",
                    ),
                  ],
                ),
                tags: ["business"],
                yt: false,
                love: 0, // You need to provide a value for `love` as it's a required field in the constructor.
              ))
        );
        case RouteName.editProfile:
        if(argument is Map){
          return MaterialPageRoute(
              builder: (BuildContext context) => EditProfile(
                name: argument["name"],));
        }else{
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
        }
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
