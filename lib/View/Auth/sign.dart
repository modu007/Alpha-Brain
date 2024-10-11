import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import '../../Bloc/AuthBloc/OtpVerficationBloc/otp_cubit.dart';
import '../../Bloc/AuthBloc/OtpVerficationBloc/otp_state.dart';
import '../../Repositories/AuthRepo/google_sign_in.dart';
import '../../Utils/Routes/route_name.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  String emailIdGoogleSignIn = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: size.height*0.6,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 20,
                    bottom: 10,
                    child: Image.asset(
                      "assets/images/sign_in.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // The gradient fade effect
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 150, // Adjust the height as needed
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.1, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height*0.12,
              width: size.width*0.3,
              child: Image.asset("assets/images/logo.png"),
            ),
            SimpleText(
                text: "Welcome to Ekonara",
                fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
            BlocConsumer<OtpCubit, OtpState>(
              listener: (context, state) {
                if (state is OtpSuccessState) {
                  Navigator.popAndPushNamed(context, RouteName.home);
                } else if (state is NewUserState) {
                  Navigator.of(context)
                      .pushNamed(RouteName.register, arguments: {
                    "emailId": emailIdGoogleSignIn,
                    "isGoogleSignIn": true,
                  });
                }
              },
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: InkWell(
                    onTap: () async {
                      if (state is! OtpLoadingState) {
                        User? user = await GoogleSignInAuth.signIn();
                        if (mounted) {
                          print("user $user");
                          if (user != null) {
                            emailIdGoogleSignIn = user.email!;
                            BlocProvider.of<OtpCubit>(context)
                                .addAddress("gmail_verified", user.email!);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Failed to sign in with google"),
                            ));
                          }
                        }
                      }
                    },
                    child: (state is OtpLoadingState)
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xffE8ECF4),
                            width: 2,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/svg/google.svg"),
                          const SizedBox(
                            width: 10,
                          ),
                          const SimpleText(
                            text: "Continue with Google",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontColor: Color(0xff6A707C),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SimpleText(
                    text: "Already have an account? ",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontColor: Colors.black),
                InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, RouteName.signInAlreadyHaveAnAccount);
                  },
                  child: const SimpleText(
                      text: "Login Now",
                      fontSize: 14,
                      fontColor: Color(0xff4EB3CA),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 10,),
            SimpleText(text: "Made in India❤️",
                fontSize: 15.sp,
              fontColor: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
