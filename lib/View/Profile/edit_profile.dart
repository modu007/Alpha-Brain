import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Bloc/EditProfileCubit/edit_profile_cubit.dart';
import 'package:neuralcode/Utils/Components/Buttons/back_buttons_text.dart';
import 'package:neuralcode/Utils/Components/Buttons/login_buttons.dart';
import 'package:provider/provider.dart';
import '../../Bloc/AuthBloc/UserDetailsBloc/user_details_cubit.dart';
import '../../Bloc/AuthBloc/UsernameCubit/username_cubit.dart';
import '../../Bloc/EditProfileCubit/edit_profile_state.dart';
import '../../Provider/dark_theme_controller.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Regex/regex.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String dob;
  final String gender;
  const EditProfile({
    super.key,
    required this.name,
    required this.dob,
    required this.gender});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

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
    dobController.text = widget.dob;
    genderController.text=widget.gender;
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
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
                const SizedBox(height: 10,),
                BackButtonText(
                  titleText: "Edit Profile",
                  onPressed: (){
                    BlocProvider.of<UserDetailsCubit>(context).getUserDetails();
                    Navigator.of(context).pop();
                    },),
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
                Container(
                  padding: const EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                      right: 25,
                      left: 15),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xffE8ECF4),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    dropdownColor: Colors.white,
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
                        child: Text(value,),
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
                BlocConsumer<EditProfileCubit, EditProfileState>(
                  listener: (context,state){
                    if(state is EditProfileSuccessState){
                      Fluttertoast.showToast(
                          msg: "Your profile has been updated successfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.black,
                          backgroundColor: Colors.white,
                          fontSize: 15.0
                      );
                    }
                  },
                builder: (context, state) {
                  if(state is EditProfileLoadingState){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  return LoginButtons(
                    size: size,
                    centerText: "Update Profile",
                    onPressed: (){
                     if(nameController.text.isNotEmpty && dobController.text.isNotEmpty){
                       BlocProvider.of<EditProfileCubit>(context)
                                .editProfile(nameController.text,
                                    dobController.text, genderController.text);
                          }
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
