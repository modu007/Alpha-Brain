import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/regex.dart';
import 'package:svg_flutter/svg.dart';
import '../../Utils/Components/Buttons/back_arrow_button.dart';
import '../../Utils/Components/Buttons/login_buttons.dart';
import '../../Utils/Components/TextField/text_field_container.dart';

class Register extends StatefulWidget {
  final String? restorationId;
  const Register({super.key, this.restorationId});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with RestorationMixin{
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
  RestorableDateTime(DateTime(2014, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1970),
          lastDate: DateTime(2015),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  DateTime? _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        // ));
      });
      return newSelectedDate;
    }else{
      return null;
    }
  }

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
                  emailController: emailController,
                  hintText: "Username",
                ),
                TextFieldContainer(
                  emailController: emailController,
                  hintText: "Date of birth",
                  suffixIcon: InkWell(
                    onTap: () {
                      _restorableDatePickerRouteFuture.present();
                    },
                    child:Image.asset("assets/images/calender.png"),
                  ),
                ),
                TextFieldContainer(
                  emailController: emailController,
                  hintText: "Gender",
                  suffixIcon: Image.asset("assets/images/down.jpg"),
                ),
                TextFieldContainer(
                  emailController: emailController,
                  hintText: "Email",
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
                LoginButtons(
                  size: size,
                  onPressed: ()async{
                    print(_selectedDate.value);
                  },
                  centerText: "Register",
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

// Scaffold(
// backgroundColor: ColorClass.backgroundColor,
// body: ColorfulSafeArea(
// color: ColorClass.backCardColor,
// child: Stack(
// children: [
// Container(
// height: size.height*0.6,
// width: size.width,
// decoration: const BoxDecoration(
// color: ColorClass.backCardColor,
// borderRadius: BorderRadius.only(
// bottomRight: Radius.circular(20),
// bottomLeft: Radius.circular(20),
// )
// ),
// ),
// Center(
// child: Container(
// height: size.height*0.8,
// padding: const EdgeInsets.only(top: 50,left: 30,right: 30),
// margin: const EdgeInsets.symmetric(horizontal: 20),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20),
// color: Colors.white
// ),
// child: SingleChildScrollView(
// child: Column(
// children: [
// TextFormContainer(
// hintText: 'Name', controller: nameController,
// onChanged: (val){
// if(val.isNotEmpty){
// setState(() {
// isNameDone=true;
// });
// }
// else{
// setState(() {
// isNameDone=false;
// });
// }
// },
// ),
// TextFormContainer(
// hintText: 'Email',
// controller: emailController,
// onChanged: (val){
// if (regex.isValidEmail(emailController.text)) {
// setState(() {
// isEmailDone = true;
// });
// } else {
// setState(() {
// isEmailDone = false;
// });
// }
// },
// ),
// Container(
// margin: const EdgeInsets.symmetric(vertical: 10),
// child: DropdownButtonFormField(
// decoration: InputDecoration(
// enabledBorder: OutlineInputBorder(
// borderSide: const BorderSide(
// width: 2,
// color: ColorClass.backCardColor),
// borderRadius: BorderRadius.circular(20),
// ),
// border: OutlineInputBorder(
// borderSide: const BorderSide(
// width: 2,
// color: ColorClass.backCardColor),
// borderRadius: BorderRadius.circular(20),
// ),
// fillColor: ColorClass.backgroundColor,
// ),
// dropdownColor: ColorClass.backgroundColor,
// value: selectedValue,
// onChanged: (val) {
// setState(() {
// selectedValue = val.toString();
// });
// },
// items: const [
// DropdownMenuItem(value: "Male", child: Text("Male")),
// DropdownMenuItem(value: "Female", child: Text("Female")),
// ]),
// ),
// Container(
// margin: const EdgeInsets.symmetric(vertical: 5),
// child: DropdownButtonFormField(
// isExpanded: true,
// decoration: InputDecoration(
// enabledBorder: OutlineInputBorder(
// borderSide: const BorderSide(
// width: 2,
// color: ColorClass.backCardColor),
// borderRadius: BorderRadius.circular(20),
// ),
// border: OutlineInputBorder(
// borderSide: const BorderSide(
// width: 2,
// color: ColorClass.backCardColor),
// borderRadius: BorderRadius.circular(20),
// ),
// fillColor: ColorClass.backgroundColor,
// ),
// dropdownColor: ColorClass.backgroundColor,
// value: selectedAge,
// onChanged: (val) {
// setState(() {
// selectedAge = val.toString();
// });
// },
// items: const [
// DropdownMenuItem(
// value: "15-30",
// child: Text("15-30")),
// DropdownMenuItem(
// value: "30-35",
// child: Text("30-35")),
// DropdownMenuItem(
// value: "35 Above",
// child: Text("35 Above")),
// ]),
// ),
// const SizedBox(height: 15,),
// const SimpleText(
// text: "We will send you-one time password(OTP)",
// fontSize: 18,
// textAlign: TextAlign.center,
// ),
// const SizedBox(height: 10,),
// const SimpleText(
// text: "Carrier rates may apply",
// fontSize: 18,
// textAlign: TextAlign.center,
// fontColor: Colors.pink,
// ),
// const SizedBox(height: 10,),
// BlocConsumer<RegisterBloc, RegisterState>(
// listener: (context, state) {
// if(state is RegistrationSuccessFullState){
// Navigator.pushNamed(context, RouteName.home);
// }
// },
// builder: (context, state) {
// if(state is RegisterLoadingState){
// return const Center(
// child: CircularProgressIndicator(),
// );
// }
// return InkWell(
// onTap: (){
// if(isEmailDone && isNameDone){
// BlocProvider.of<RegisterBloc>(context)
//     .add(RegisterDataEvent(
// email: emailController.text,
// name: nameController.text,
// age: selectedAge,
// gender: selectedValue));
// }
// },
// child: Container(
// width: 60,
// height: 60,
// padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
// margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(40),
// color: isEmailDone && isNameDone ?
// ColorClass.backCardColor:Colors.black45,
// ),
// child:  Center(
// child: SvgPicture.asset("assets/svg/next.svg"),
// ),
// ),
// );
// },
// )
// ],
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// );