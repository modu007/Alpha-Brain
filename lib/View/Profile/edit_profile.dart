import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Utils/Components/Buttons/back_buttons_text.dart';
import 'package:neuralcode/Utils/Components/Buttons/login_buttons.dart';

import '../../Bloc/AuthBloc/UsernameCubit/username_cubit.dart';
import '../../Bloc/AuthBloc/UsernameCubit/username_state.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Regex/regex.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final focusNode = FocusNode();
  bool isEmailValid = false;
  bool isUserNameValid = false;
  late Regex regex;
  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  @override
  void initState() {
    BlocProvider.of<UsernameCubit>(context).userInitialEvent();
    focusNode.addListener(() {
      if(!focusNode.hasFocus){
        BlocProvider.of<UsernameCubit>(context).usernameAvailability(
            usernameController.text);
      }
    });
    super.initState();
    regex= Regex();
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const BackButtonText(titleText: "Edit Profile"),
                const SizedBox(height: 20,),
                TextFieldContainer(
                  emailController: nameController,
                  hintText: "Full Name",
                ),
                BlocBuilder<UsernameCubit,UsernameState>(
                  builder: (context, state) {
                    if(state is UsernameSuccessState){
                      isUserNameValid =true;
                      return Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xffE8ECF4),
                            borderRadius: BorderRadius.circular(10)
                        ),
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
                              contentPadding: const EdgeInsets.only(left: 15)
                          ),
                        ),
                      );
                    }
                    else if (state is UsernameExistsState){
                      isUserNameValid =false;
                      return Column(
                        children: [
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color(0xffE8ECF4),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              focusNode: focusNode,
                              controller: usernameController,
                              decoration: InputDecoration(
                                  suffixIcon: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: Image.asset("assets/images/Cancel.jpg"),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "UserName",
                                  hintStyle: GoogleFonts.besley(
                                    color: const Color(0xff8391A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 15)
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: SimpleText(
                              text: "That username has taken. Please enter another.",
                              fontSize: 12,
                              fontColor: Colors.red,
                            ),
                          )
                        ],
                      );
                    }
                    isUserNameValid =false;
                    return Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xffE8ECF4),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
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
                            contentPadding: const EdgeInsets.only(left: 15)
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10,),
                TextFieldContainer(
                  emailController: dobController,
                  hintText: "Date of birth",
                  readOnly: true,
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
                      right: 25,left: 15,top: 10,bottom: 10),
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
                      border: InputBorder.none,
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
                const SizedBox(height: 10,),
                LoginButtons(
                    size: size,
                    centerText: "Update Profile",
                    onPressed: (){

                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
