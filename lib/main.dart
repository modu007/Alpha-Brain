import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neuralcode/Bloc/AuthBloc/OtpVerficationBloc/otp_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/RegisterBloc/register_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/SignInBloc/sign_in_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/UploadProfileCubit/upload_image_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/UserDetailsBloc/user_details_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/UsernameCubit/username_cubit.dart';
import 'package:neuralcode/Bloc/EditProfileCubit/edit_profile_cubit.dart';
import 'package:neuralcode/Bloc/GetInterets/get_interests_cubit.dart';
import 'package:neuralcode/Bloc/InterestCubit/interests_cubit.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_bloc.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_bloc.dart';
import 'package:neuralcode/Bloc/TagsBloc/tags_cubit.dart';
import 'package:neuralcode/Provider/dark_theme_controller.dart';
import 'package:neuralcode/firebase_options.dart';
import 'package:provider/provider.dart';
import 'Bloc/HomeBloc/home_bloc.dart';
import 'Core/FirebasePushNotificationService/firebase_push_notificatioin_services.dart';
import 'SharedPrefernce/shared_pref.dart';
import 'Utils/Routes/route_name.dart';
import 'Utils/Routes/routes.dart';
import 'Utils/Style/style.dart';

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  print("handling a message id ${message.messageId}");
  print(message.data);
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  List? customInterests = await SharedData.getToken("custom");
  List? savedInterests = await SharedData.getToken("interests");
  if(customInterests==null){
    SharedData.saveCustomInterests([]);
  }
  if(savedInterests==null){
    SharedData.saveInterests([]);
  }
  await PushNotificationServices.firebaseCloudMessaging();
  await PushNotificationServices.localNotificationInitialization();
  PushNotificationServices.saveFcmToken();
  PushNotificationServices.incomingMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  PushNotificationServices.onClickNotification.stream.listen((remoteMessage){
    navigatorKey.currentState?.restorablePushNamed(
       RouteName.notificationPost,
     arguments: {
       "postId" :remoteMessage["post_id"]
     });
  });
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      navigatorKey.currentState?.restorablePushNamed(
          RouteName.splash,arguments: {
        "fromBackground":true,
        "postId":message.data["post_id"]
      });
    }
  });
  final String languageCode =
      await SharedLanguageData.getLanguageData('lang') ?? '';
  languageCode == ""
      ? await SharedLanguageData.setToken("en")
      : await SharedLanguageData.getLanguageData("lang");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
            create: (BuildContext context) =>HomeBloc()),
        BlocProvider<RegisterBloc>(
            create: (BuildContext context) =>RegisterBloc()),
        BlocProvider<SignInBloc>(
            create: (BuildContext context) =>SignInBloc()),
        BlocProvider<OtpCubit>(
            create: (BuildContext context) =>OtpCubit()),
        BlocProvider<UsernameCubit>(
            create: (BuildContext context) =>UsernameCubit()),
        BlocProvider<ProfileBloc>(
            create: (BuildContext context) =>ProfileBloc()),
        BlocProvider<UploadImageCubit>(
            create: (BuildContext context) =>UploadImageCubit()),
        BlocProvider<UserDetailsCubit>(
            create: (BuildContext context) =>UserDetailsCubit()),
        BlocProvider<EditProfileCubit>(
            create: (BuildContext context) =>EditProfileCubit()),
        BlocProvider<TagsCubit>(
            create: (BuildContext context) =>TagsCubit()),
        BlocProvider<NotificationPostBloc>(
            create: (BuildContext context) =>NotificationPostBloc()),
        BlocProvider<InterestsCubit>(
            create: (BuildContext context) =>InterestsCubit()),
        BlocProvider<GetInterestsCubit>(
            create: (BuildContext context) =>GetInterestsCubit()),
        ChangeNotifierProvider<DarkThemeProvider>(
            create: (BuildContext context) => DarkThemeProvider())
      ],
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            initialRoute: RouteName.splash,
            onGenerateRoute: Routes.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(value.darkTheme, context),
          );
        }
      ),
    );
  }
}
