import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Api/all_api.dart';
import 'package:neuralcode/Bloc/AuthBloc/UsernameCubit/username_cubit.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Regex/regex.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Bloc/AuthBloc/RegisterBloc/register_bloc.dart';
import '../../Bloc/AuthBloc/RegisterBloc/register_event.dart';
import '../../Bloc/AuthBloc/RegisterBloc/register_state.dart';
import '../../Bloc/AuthBloc/UsernameCubit/username_state.dart';
import '../../Utils/Components/Buttons/back_arrow_button.dart';
import '../../Utils/Components/Buttons/login_buttons.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Routes/route_name.dart';

class Register extends StatefulWidget {
  final String? emailId;
  final bool isGoogleSignIn;
  const Register({super.key, this.emailId, this.isGoogleSignIn = false});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  final focusNode = FocusNode();
  bool isEmailValid = false;
  bool isFullNameDone = false;
  bool isUserNameValid = false;
  bool isDobDone = false;
  late Regex regex;
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String dob = "";
  bool isEmailDone = false;
  bool isNameDone = false;

  @override
  void initState() {
    if (widget.emailId != null) {
      emailController.text = widget.emailId!;
      if (emailController.text.contains('@')) {
        isEmailValid = true;
      }
    }
    genderController.text = "Male";
    languageController.text = "English";
    BlocProvider.of<UsernameCubit>(context).userInitialEvent();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        BlocProvider.of<UsernameCubit>(context)
            .usernameAvailability(usernameController.text.toLowerCase());
      }
    });
    super.initState();
    regex = Regex();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    dobController.dispose();
    genderController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonContainer(
                  onPressed: () {
                    Navigator.of(context);
                  },
                  headingText: "Hello! Register to get started",
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFieldContainer(
                  emailController: nameController,
                  hintText: "Full Name",
                  onChanged: (val) {
                    if (val.isNotEmpty && val.length >= 3) {
                      isFullNameDone = true;
                    } else {
                      isFullNameDone = false;
                    }
                  },
                ),
                BlocBuilder<UsernameCubit, UsernameState>(
                  builder: (context, state) {
                    if (state is UsernameLoading) {
                      return Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xffE8ECF4),
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            TextFormField(
                              focusNode: focusNode,
                              controller: usernameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "UserName",
                                  hintStyle: GoogleFonts.besley(
                                    color: const Color(0xff8391A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 15, top: 10)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child:
                                      CircularProgressIndicator(), // CircularProgressIndicator with fixed size
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is UsernameSuccessState) {
                      isUserNameValid = true;
                      return Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xffE8ECF4),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: usernameController,
                          decoration: InputDecoration(
                              suffixIcon: SizedBox(
                                height: 10,
                                width: 10,
                                child: Image.asset("assets/images/Right.jpg"),
                              ),
                              border: InputBorder.none,
                              hintText: "UserName",
                              hintStyle: GoogleFonts.besley(
                                color: const Color(0xff8391A1),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 15, top: 10)),
                        ),
                      );
                    } else if (state is UsernameExistsState) {
                      isUserNameValid = false;
                      return Column(
                        children: [
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color(0xffE8ECF4),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              focusNode: focusNode,
                              controller: usernameController,
                              decoration: InputDecoration(
                                  suffixIcon: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child:
                                        Image.asset("assets/images/Cancel.jpg"),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "UserName",
                                  hintStyle: GoogleFonts.besley(
                                    color: const Color(0xff8391A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 15)),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: SimpleText(
                              text:
                                  "That username has taken. Please enter another.",
                              fontSize: 12,
                              fontColor: Colors.red,
                            ),
                          )
                        ],
                      );
                    }
                    isUserNameValid = false;
                    return Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xffE8ECF4),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        focusNode: focusNode,
                        controller: usernameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "UserName",
                            hintStyle: GoogleFonts.besley(
                              color: const Color(0xff8391A1),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: const EdgeInsets.only(left: 15)),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldContainer(
                  emailController: dobController,
                  hintText: "Date of birth",
                  readOnly: true,
                  suffixIcon: InkWell(
                    onTap: () async {
                      DateTime? datePicked = await showDatePicker(
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2016));
                      setState(() {
                        dobController.text = ""
                            "${datePicked?.day.toString() ?? 01}-"
                            "${datePicked?.month.toString() ?? 01}-"
                            "${datePicked?.year.toString() ?? 2016}";
                      });
                      isDobDone = true;
                    },
                    child: Image.asset("assets/images/calender.png"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      right: 25, left: 15, top: 10, bottom: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xffE8ECF4),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonFormField<String>(
                    icon: SvgPicture.asset("assets/svg/down_arrow.svg"),
                    value: genderController.text.isEmpty
                        ? null
                        : genderController.text,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        genderController.text = newValue;
                      }
                    },
                    items: ['Male', 'Female']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(
                      hintText: "Gender",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.besley(
                        color: const Color(0xff8391A1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldContainer(
                  inputFormatter: [EmailInputFormatter()],
                  keyboardType: TextInputType.emailAddress,
                  emailController: emailController,
                  hintText: "Email",
                  onChanged: (val){
                    if(regex.isValidEmail(val)){
                      isEmailValid=true;
                    }
                    else{
                      isEmailValid=false;
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(
                      right: 25, left: 15, top: 10, bottom: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xffE8ECF4),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonFormField<String>(
                    icon: SvgPicture.asset("assets/svg/down_arrow.svg"),
                    value: languageController.text.isEmpty
                        ? null
                        : languageController.text,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        languageController.text = newValue;
                      }
                    },
                    items: ['Hindi', 'English']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(
                      hintText: "Select Language",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.besley(
                        color: const Color(0xff8391A1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!widget.isGoogleSignIn)
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
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegistrationSuccessFullState) {
                      if (widget.isGoogleSignIn) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteName.home, (route) => false);
                      } else {
                        BlocProvider.of<RegisterBloc>(context)
                            .add(SendOtp(email: state.email));
                    }
                    }
                    if(state is OtpSendState){
                      Navigator.of(context).pushNamed(
                        RouteName.otpVerification,arguments: {
                          "email":state.email
                      });
                      }
                    if(state is OtpSendState){
                      Navigator.of(context).pushNamed(
                        RouteName.otpVerification,arguments: {
                          "email":state.email
                      });
                    }
                    if (state is OtpSendState) {
                      Navigator.of(context).pushNamed(RouteName.otpVerification,
                          arguments: {"email": state.email});
                    }
                    if (state is UsernameInvalidState) {
                      Fluttertoast.showToast(
                          msg: "Invalid username",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.black,
                          fontSize: 15.0);
                    }
                    if (state is FullNameInvalidState) {
                      Fluttertoast.showToast(
                          msg:
                              "Either the name field is empty or the length should be greater than 3 characters ",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.black,
                          fontSize: 15.0);
                    }
                    if (state is EmailInvalidState) {
                      Fluttertoast.showToast(
                          msg: "Invalid Email",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.black,
                          fontSize: 15.0);
                    }
                  },
                  builder: (context, state) {
                    if (state is RegisterLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return LoginButtons(
                      size: size,
                      onPressed: () async {
                        print(isEmailValid);
                        BlocProvider.of<RegisterBloc>(context)
                            .add(RegisterDataEvent(
                          email: emailController.text,
                          name: nameController.text,
                          age: dobController.text,
                          gender: genderController.text,
                          username: usernameController.text.toLowerCase(),
                          isUsernameValid: isUserNameValid,
                          fullNameValid: isFullNameDone,
                          isEmailValid: isEmailValid,
                          dob: isDobDone,
                          language: languageController.text,
                          isGoogleSignIn: widget.isGoogleSignIn,
                        ));
                      },
                      centerText: "Register",
                    );
                  },
                ),
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 20),
                //   child: const Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Expanded(
                //           child: Divider(
                //             color: Color(0xffE8ECF4),
                //             thickness: 1,
                //           )),
                //       Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 10),
                //         child: SimpleText(
                //           text: "Or Register with",
                //           fontSize: 14,
                //           fontFamily: 'Poppins',
                //           fontWeight: FontWeight.w400,
                //           fontColor: Colors.black,
                //         ),
                //       ),
                //       Expanded(
                //           child: Divider(
                //             thickness: 1,
                //             color: Color(0xffE8ECF4),
                //           )),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20,),
                // Container(
                //   width: size.width,
                //   padding: const EdgeInsets.symmetric(vertical: 15),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: const Color(0xffE8ECF4),
                //       )
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset("assets/svg/google.svg"),
                //       const SizedBox(width: 10,),
                //       const SimpleText(
                //         text: "Continue with Google",
                //         fontSize: 15,
                //         fontWeight: FontWeight.w500,
                //         fontColor: Color(0xff6A707C),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SimpleText(
                            text: "By proceeding, you agree to Z Alpha Brains ",
                            fontSize: 12),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(
                                Uri.parse(AllApi.termsAndCondition))) {
                              throw Exception('Could not launch url');
                            }
                          },
                          child: const SimpleText(
                            text: "Terms of Service.",
                            fontSize: 12,
                            fontColor: Color(0xff4EB3CA),
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                        const SimpleText(
                            text: "We will manage information about",
                            fontSize: 12),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SimpleText(
                            text: "you as described in ", fontSize: 12),
                        const SimpleText(text: "our ", fontSize: 12),
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(
                                Uri.parse(AllApi.termsAndCondition))) {
                              throw Exception('Could not launch url');
                            }
                          },
                          child: const SimpleText(
                            text: "Privacy Policy ",
                            fontSize: 12,
                            fontColor: Color(0xff4EB3CA),
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                        const SimpleText(text: "and ", fontSize: 12),
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(
                                Uri.parse(AllApi.termsAndCondition))) {
                              throw Exception('Could not launch url');
                            }
                          },
                          child: const SimpleText(
                            text: "Cookie Policy.",
                            fontSize: 12,
                            fontColor: Color(0xff4EB3CA),
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
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
                        Navigator.popAndPushNamed(context, RouteName.signIn);
                      },
                      child: const SimpleText(
                          text: "Login Now",
                          fontSize: 14,
                          fontColor: Color(0xff4EB3CA),
                          fontWeight: FontWeight.bold),
                    )
                  ],
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
