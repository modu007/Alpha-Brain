import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import 'package:neuralcode/Utils/Data/local_data.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:provider/provider.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';
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
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
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
        NavigationService.navigateToNotificationPost(
            postId: widget.postId!, fromBackGround: true);
      }
    }
    else{
      NetworkRequest networkRequest = NetworkRequest();
      if (token != null) {
        bool hasExpired = JwtDecoder.isExpired(token);
        if(hasExpired){
          var res = await networkRequest.refreshToken({}, AllApi.generateToken);
          if(res["Token"]!= null){
            SharedData.setToken(res["Token"]);
          }
        }
        Timer(
            const Duration(seconds: 5),
                () => Navigator.of(context).restorablePushNamedAndRemoveUntil(
                RouteName.home, (route) => false)
        );
      }
      else {
        Timer(const Duration(seconds: 3),
                () => Navigator.of(context).popAndPushNamed(RouteName.signIn));
      }
    }
  }
  bool onlyOnce=false;
  void getCurrentAppTheme(BuildContext context) async {
    bool theme =
    await themeChangeProvider.darkThemePreference.getTheme();
    final themeChange = Provider.of<DarkThemeProvider>(context,listen: false);
    themeChange.setDarkTheme=theme;
  }

  @override
  void didChangeDependencies() async{
    splash();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(onlyOnce==false){
      getCurrentAppTheme(context);
      onlyOnce=true;
    }
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
            // const SimpleText(text: "Ekonara", fontSize: 25),
          ],
        ),
      ),
    );
  }
}