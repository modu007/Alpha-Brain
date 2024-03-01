import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/EditProfileCubit/edit_profile_cubit.dart';
import 'package:neuralcode/Utils/Components/Buttons/back_buttons_text.dart';
import 'package:neuralcode/Utils/Components/Buttons/login_buttons.dart';
import '../../Bloc/AuthBloc/UsernameCubit/username_cubit.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Regex/regex.dart';

class EditProfile extends StatefulWidget {
  final String name;
  const EditProfile({
    super.key,
    required this.name});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  bool isEmailValid = false;
  bool isUserNameValid = false;
  late Regex regex;
  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  @override
  void initState() {
    nameController.text =widget.name;
    BlocProvider.of<UsernameCubit>(context).userInitialEvent();
    super.initState();
    regex= Regex();
  }
  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
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
                            "${datePicked?.day.toString() ?? 01}-"
                            "${datePicked?.month.toString() ?? 01}-"
                            "${datePicked?.year.toString()?? 2016}";
                      });
                    },
                    child:Image.asset("assets/images/calender.png"),
                  ),
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
                     if(nameController.text.isNotEmpty && dobController.text.isNotEmpty){
                       BlocProvider.of<EditProfileCubit>(context)
                           .editProfile(nameController.text,dobController.text);
                     }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
