import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/TagsBloc/tags_cubit.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Data/local_data.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/GetInterets/get_interests_cubit.dart';
import '../../Provider/dark_theme_controller.dart';
import '../../Utils/Routes/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  final bool? fromBackGround;
  final String? postId;
  const SplashScreen({super.key,
    this.fromBackGround,
    this.postId});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  Future splash() async {
    List customInterests = await SharedData.getToken("custom");
    List savedInterests = await SharedData.getToken("interests");
    List<String> custom=[];
    List<String> interest=[];
    for(int i=0; i<customInterests.length;i++){
      custom.add(customInterests[i]);
    }
    for(int i=0; i<savedInterests.length;i++){
      interest.add(savedInterests[i]);
    }
    LocalData.getUserInterestsSelected.addAll(interest);
    LocalData.getCustomTags.addAll(custom);
    var token = await SharedData.getToken("token");
    if(widget.fromBackGround != null){
      if(widget.fromBackGround == true){
        NavigationService.navigateToNotificationPost(widget.postId!);
      }
    }else{
      if (token != null) {
        Timer(
            const Duration(seconds: 4),
                () => Navigator.of(context).restorablePushNamedAndRemoveUntil(
                RouteName.home, (route) => false));
      }
      else {
        Timer(const Duration(seconds: 3),
                () => Navigator.of(context).popAndPushNamed(RouteName.signIn));
      }
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void didChangeDependencies() async{
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkTheme = await DarkThemePreference.getTheme();
    themeChange.darkTheme = isDarkTheme;
    splash();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: const Color(0xffd4edf4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffd4edf4)),
              child: Image.asset("assets/images/logo.png"),
            ),
            const SimpleText(text: "Z-Alpha Brains", fontSize: 25),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: LinearProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
