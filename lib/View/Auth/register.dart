import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/regex.dart';
import 'package:svg_flutter/svg.dart';
import '../../Bloc/AuthBloc/register_bloc.dart';
import '../../Bloc/AuthBloc/register_event.dart';
import '../../Bloc/AuthBloc/register_state.dart';
import '../../Utils/Components/Buttons/back_arrow_button.dart';
import '../../Utils/Components/Buttons/login_buttons.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Routes/route_name.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  bool isEmailValid = false;
  late Regex regex;
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String selectedValue = "Male";
  String dob = "15-30";
  bool isEmailDone =false;
  bool isNameDone =false;

@override
  void initState() {
    super.initState();
     regex= Regex();
  }
  @override
  void dispose() {
  nameController.dispose();
  emailController.dispose();
  usernameController.dispose();
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
                  onPressed: () {},
                  headingText: "Hello! Register to get started",),
                const SizedBox(height: 40,),
                TextFieldContainer(
                    emailController: emailController,
                  hintText: "Full Name",
                ),
                TextFieldContainer(
                  emailController: usernameController,
                  hintText: "Username",
                ),
                TextFieldContainer(
                  emailController: dobController,
                  hintText: "Date of birth",
                  suffixIcon: InkWell(
                    onTap: () async{
                      DateTime? datePicked = await showDatePicker(
                          context: context,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2016));
                      setState(() {
                        dobController.text=""
                            "${datePicked?.day.toString()}-"
                            "${datePicked?.month.toString()}-"
                            "${datePicked?.year.toString()}";
                      });
                    },
                    child:Image.asset("assets/images/calender.png"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      right: 10,),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xffE8ECF4),
                    borderRadius: BorderRadius.circular(10)
                  ),
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
                    ).toList(),
                    decoration: InputDecoration(
                    hintText: "Gender",
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffE8ECF4),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff4EB3CA),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    hintStyle: GoogleFonts.besley(
                    color: const Color(0xff8391A1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFieldContainer(
                  emailController: emailController,
                  hintText: "Email",
                  validator: (val){
                    if(regex.isValidEmail(emailController.text)){
                      setState(() {
                        isEmailValid=true;
                      });
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: SimpleText(
                      text: "A verification code will be sent to the email you provide.",
                      fontSize: 12,
                      fontColor: Color(0xff6A707C),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegistrationSuccessFullState) {
                      Navigator.pushNamed(context, RouteName.home);
                    }
                  },
                  builder: (context,state){
                    if (state is RegisterLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return LoginButtons(
                      size: size,
                      onPressed: ()async{
                        BlocProvider.of<RegisterBloc>(context)
                            .add(RegisterDataEvent(
                            email: emailController.text,
                            name: nameController.text,
                            age: dobController.text,
                            gender: selectedValue));
                      },
                      centerText: "Register",
                    );
                  },
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
                          text: "Or Register with",
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
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SimpleText(text: "Already have an account? ",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontColor: Colors.black),
                    InkWell(
                      onTap: () {
                        // Navigator.pushReplacementNamed(
                        //     context, RouteName.signIn);
                      },
                      child: const SimpleText(
                          text: "Login Now",
                          fontSize: 14,
                          fontColor: Color(0xff4EB3CA),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}