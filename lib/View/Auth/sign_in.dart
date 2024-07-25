import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neuralcode/Bloc/AuthBloc/OtpVerficationBloc/otp_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/OtpVerficationBloc/otp_state.dart';
import 'package:neuralcode/Bloc/AuthBloc/SignInBloc/sign_in_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/SignInBloc/sign_in_event.dart';
import 'package:neuralcode/Bloc/AuthBloc/SignInBloc/sign_in_state.dart';
import 'package:neuralcode/Repositories/AuthRepo/google_sign_in.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:provider/provider.dart';
import '../../Provider/dark_theme_controller.dart';
import '../../Utils/Components/Buttons/back_arrow_button.dart';
import '../../Utils/Components/Buttons/login_buttons.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Regex/regex.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  String emailIdGoogleSignIn = '';
  late Regex regex;
  bool isValidEmail = false;
  @override
  void initState() {
    regex = Regex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SimpleText(
                  text: "Don’t have an account? ",
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontColor: Colors.black),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, RouteName.register);
                },
                child: SimpleText(
                    text: "Register Now",
                    fontSize: 14,
                    fontColor: themeChange.darkTheme
                        ? const Color(0xff4EB3CA)
                        : const Color(0xff4EB3CA),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonContainer(
                  onPressed: () {},
                  headingText: "Welcome back! Glad to see you, Again!",
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFieldContainer(
                  keyboardType: TextInputType.emailAddress,
                  emailController: emailController,
                  inputFormatter: [EmailInputFormatter()],
                  hintText: "Enter your email",
                  onChanged: (val) {
                    if (val.contains('@')) {
                      setState(() {
                        isValidEmail = true;
                      });
                    } else {
                      setState(() {
                        isValidEmail = false;
                      });
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: SimpleText(
                      text:
                      "A verification code will be sent to the email you provide.",
                      fontSize: 12,
                      fontColor: Color(0xff6A707C),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocConsumer<SignInBloc, SignInState>(
                  listenWhen: (previous, current) =>
                  current is SignInActionState,
                  buildWhen: (previous, current) =>
                  current is! SignInActionState,
                  listener: (context, state) {
                    if (state is InvalidEmailState) {
                      Navigator.of(context)
                          .pushNamed(RouteName.register, arguments: {
                        "emailId": emailController.text,
                      });
                      Fluttertoast.showToast(
                          msg: "Email id does not exist please register",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.black,
                          backgroundColor: Colors.white,
                          fontSize: 15.0
                      );
                    }
                    if (state is SignInSuccessState) {
                      Navigator.pushNamed(context, RouteName.otpVerification,
                          arguments: {"email": emailController.text});
                    }
                  },
                  builder: (context, state) {
                    if (state is SignInLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return LoginButtons(
                      size: size,
                      onPressed: () {
                        BlocProvider.of<SignInBloc>(context).add(LoginEvent(
                            email: emailController.text,
                            isValidEmail: isValidEmail));
                      },
                      centerText: "Login",
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Divider(
                            color: Color(0xffE8ECF4),
                            thickness: 1,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SimpleText(
                          text: "Or Login with",
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontColor: Colors.black,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color(0xffE8ECF4),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                    return InkWell(
                      onTap: () async {
                        if (state is! OtpLoadingState) {
                          User? user = await GoogleSignInAuth.signIn();
                          if (mounted) {
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
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}