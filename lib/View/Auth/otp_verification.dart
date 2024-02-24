import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neuralcode/Bloc/AuthBloc/OtpVerficationBloc/otp_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/OtpVerficationBloc/otp_state.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:pinput/pinput.dart';
import '../../Utils/Components/Buttons/back_arrow_button.dart';
import '../../Utils/Components/Buttons/login_buttons.dart';

class OtpVerification extends StatefulWidget {
  final String email;

  const OtpVerification({super.key, required this.email});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController otpController = TextEditingController();
  bool isValidate = false;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonContainer(
                onPressed: () {},
                headingText: "OTP Verification",),
              const SizedBox(height: 10,),
              const SimpleText(
                text: "Enter the verification code we just sent on your email address. ",
                fontSize: 16,
                fontColor: Color(0xff838BA1),
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 30,),
              Center(
                child: Pinput(
                  controller: otpController,
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {
                    if (value.length == 6) {
                      setState(() {
                        isValidate = true;
                      });
                    }
                    else {
                      isValidate = false;
                    }
                  },
                  defaultPinTheme: PinTheme(
                    width: size.width,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isValidate == true ?
                          const Color(0xff4EB3CA) :
                          Colors.red),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              BlocConsumer<OtpCubit, OtpState>(
                listener: (context, state) {
                 if(state is OtpSuccessState){
                   Navigator.pushNamedAndRemoveUntil(
                       context,
                       RouteName.home,
                           (route) => false);
                 }
                 if(state is OtpInvalidState){
                   Fluttertoast.showToast(
                       msg: "Invalid otp",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.CENTER,
                       timeInSecForIosWeb: 1,
                       textColor: Colors.black,
                       fontSize: 15.0
                   );
                 }
                },
                builder: (context, state) {
                  if(state is OtpLoadingState){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  return LoginButtons(
                    size: size,
                    onPressed: () {
                      if (isValidate) {
                        BlocProvider.of<OtpCubit>(context).addAddress(
                            otpController.text, widget.email);
                      }
                    },
                    centerText: "Verify",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
