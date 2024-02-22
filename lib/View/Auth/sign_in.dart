import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:svg_flutter/svg.dart';
import '../../Utils/Components/Buttons/back_arrow_button.dart';
import '../../Utils/Components/Buttons/login_buttons.dart';
import '../../Utils/Components/TextField/text_field_container.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               BackButtonContainer(
                 onPressed: (){},
                 headingText: "Welcome back! Glad to see you, Again!",),
              const SizedBox(height: 40,),
              TextFieldContainer(
                emailController: emailController,
                hintText: "Enter your email",),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child:  SimpleText(
                      text: "A verification code will be sent to the email you provide.",
                      fontSize: 12,
                    fontColor: Color(0xff6A707C),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              LoginButtons(
                size: size,
                onPressed: (){},
                centerText: "Login",
              ),
              const SizedBox(height: 30,),
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
              const SizedBox(height: 20,),
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xffE8ECF4),
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/google.svg"),
                    const SizedBox(width: 10,),
                    const SimpleText(
                      text: "Continue with Google",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontColor: Color(0xff6A707C),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SimpleText(text:"Don’t have an account? " ,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      fontColor: Colors.black) ,
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, RouteName.register);
                    },
                    child: const SimpleText(
                        text:"Register Now" ,
                        fontSize: 14,
                        fontColor:  Color(0xff4EB3CA),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}




