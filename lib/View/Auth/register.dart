import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/register_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/register_state.dart';
import 'package:neuralcode/Utils/Color/colors.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:neuralcode/Utils/regex.dart';
import 'package:svg_flutter/svg.dart';
import '../../Bloc/AuthBloc/register_event.dart';
import '../../Utils/Components/TextField/text_from_conatiner.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late Regex regex;
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String selectedValue = "Male";
  String selectedAge = "15-30";
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
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: ColorClass.backgroundColor,
      body: ColorfulSafeArea(
        color: ColorClass.backCardColor,
        child: Stack(
          children: [
            Container(
              height: size.height*0.6,
              width: size.width,
              decoration: const BoxDecoration(
                color: ColorClass.backCardColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              ),
            ),
            Center(
              child: Container(
                height: size.height*0.8,
                padding: const EdgeInsets.only(top: 50,left: 30,right: 30),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // const SimpleText(text: "Register", fontSize: 18),
                      TextFormContainer(
                        hintText: 'Name', controller: nameController,
                        onChanged: (val){
                          if(val.isNotEmpty){
                            setState(() {
                              isNameDone=true;
                            });
                          }
                          else{
                            setState(() {
                              isNameDone=false;
                            });
                          }
                        },
                      ),
                      TextFormContainer(
                        hintText: 'Email',
                        controller: emailController,
                        onChanged: (val){
                          if (regex.isValidEmail(emailController.text)) {
                            setState(() {
                              isEmailDone = true;
                            });
                          } else {
                            setState(() {
                              isEmailDone = false;
                            });
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2,
                                    color: ColorClass.backCardColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2,
                                    color: ColorClass.backCardColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: ColorClass.backgroundColor,
                            ),
                            dropdownColor: ColorClass.backgroundColor,
                            value: selectedValue,
                            onChanged: (val) {
                              setState(() {
                                selectedValue = val.toString();
                              });
                            },
                            items: const [
                              DropdownMenuItem(value: "Male", child: Text("Male")),
                              DropdownMenuItem(value: "Female", child: Text("Female")),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2,
                                    color: ColorClass.backCardColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2,
                                    color: ColorClass.backCardColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: ColorClass.backgroundColor,
                            ),
                            dropdownColor: ColorClass.backgroundColor,
                            value: selectedAge,
                            onChanged: (val) {
                              setState(() {
                                selectedAge = val.toString();
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                  value: "15-30",
                                  child: Text("15-30")),
                              DropdownMenuItem(
                                  value: "30-35",
                                  child: Text("30-35")),
                              DropdownMenuItem(
                                  value: "35 Above",
                                  child: Text("35 Above")),
                            ]),
                      ),
                      const SizedBox(height: 15,),
                      const SimpleText(
                          text: "We will send you-one time password(OTP)",
                          fontSize: 18,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10,),
                      const SimpleText(
                        text: "Carrier rates may apply",
                        fontSize: 18,
                        textAlign: TextAlign.center,
                        fontColor: Colors.pink,
                      ),
                      const SizedBox(height: 10,),
                      BlocConsumer<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if(state is RegistrationSuccessFullState){
                            Navigator.pushNamed(context, RouteName.home);
                          }
                        },
                        builder: (context, state) {
                          if(state is RegisterLoadingState){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return InkWell(
                            onTap: (){
                              BlocProvider.of<RegisterBloc>(context)
                                  .add(RegisterDataEvent(
                                  email: emailController.text,
                                  name: nameController.text,
                                  age: selectedAge,
                                  gender: selectedValue));
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: isEmailDone && isNameDone ?
                                ColorClass.backCardColor:Colors.black45,
                              ),
                              child:  Center(
                                child: SvgPicture.asset("assets/svg/next.svg"),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

