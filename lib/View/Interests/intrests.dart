import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neuralcode/Bloc/InterestCubit/interests_cubit.dart';
import 'package:neuralcode/Bloc/InterestCubit/interests_state.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text2.dart';
import 'package:provider/provider.dart';
import '../../Bloc/GetInterets/get_interests_cubit.dart';
import '../../Bloc/GetInterets/get_interests_state.dart';
import '../../Provider/dark_theme_controller.dart';
import '../../Utils/Components/Buttons/login_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Data/local_data.dart';
import '../../Utils/Routes/route_name.dart';

class Interests extends StatefulWidget {
  const Interests({super.key});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final TextEditingController search = TextEditingController();
  final TextEditingController customTagsController = TextEditingController();
  final List<String> items = [];
  final List<String> selectedInterests =[];
  final List<String> customTags =[];
  bool customTagsTextEmpty=true;
  bool onlyOnce =false;
  List<String> localSearch=[];
  bool isEmpty = false;
  Future<void> showAddCustomTagsDialog(BuildContext context, Size size,DarkThemeProvider themeChange) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
              height: size.height * 0.35,
              width: size.width - 30,
              padding:
              const EdgeInsets.only(bottom: 15, left: 20, right: 20, top: 15),
              decoration: BoxDecoration(
                color:themeChange.darkTheme? const Color(0xff1E1E1E):Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Expanded(child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                          SimpleText2(
                           text: "Add a new interest",
                           fontSize: 17,
                           fontWeight: FontWeight.w500,
                           fontColor: themeChange.darkTheme?Colors.white:Colors.black,
                         ),
                         InkWell(
                             onTap: () {
                               Navigator.of(context).pop();
                             },
                             child: const Icon(
                               Icons.close,
                               color: Color(0xff6A707C),
                             )),
                       ],
                     ),
                     const SizedBox(height: 10,),
                     const Divider(
                       color: Color(0xffD1D3D4),
                     ),
                     const SizedBox(height: 15,),
                     TextFieldContainer(
                       keyboardType: TextInputType.visiblePassword,
                       emailController: customTagsController,
                       hintText: "Add interest ex. Virat Kohli",
                       onChanged: (val) {
                         if (val.isNotEmpty && val.length >= 3) {
                           customTagsTextEmpty = false;
                         } else {
                           customTagsTextEmpty = true;
                         }
                       },
                     ),
                   ],
                 )),
                  LoginButtons(
                  size: size, centerText: "Add interest", onPressed: () {
                   if(customTagsTextEmpty == false){
                     setState(() {
                       customTags.add(customTagsController.text);
                     });
                     Fluttertoast.showToast(
                         msg: "Interests added successfully",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.BOTTOM,
                         textColor: Colors.black,
                         backgroundColor: Colors.white,
                         fontSize: 15.0
                     );
                     customTagsController.clear();
                     FocusManager.instance.primaryFocus?.unfocus();
                   }
                  }),
              const SizedBox(height: 5,),
              const SimpleText(
                text:
                    "Note: Please add your custom tags with proper spelling for better results",
                fontSize: 13,
                textAlign: TextAlign.center,
              )
            ],
              ),
            ));
      },
    );
  }
  @override
  void initState() {
    BlocProvider.of<GetInterestsCubit>(context).getAllAndSelectedInterests();
    super.initState();
  }
  @override
  void dispose() {
    search.dispose();
    customTagsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:  Container(
          margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
          height: size.height*0.18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             LoginButtons(
                 color: null,
                 size: size,
                 centerText: "Add custom tag",
                 onPressed: () {
                   showAddCustomTagsDialog(
                       context,size,
                     themeChange
                   );
                 }),
             const SizedBox(height: 10,),
             BlocConsumer<InterestsCubit, InterestsState>(
               listener: (context, state) {
                 if(state is AtLeastTwoInterests){
                   Fluttertoast.showToast(
                       msg: "At least two interest need to be selected",
                       toastLength: Toast.LENGTH_LONG,
                       gravity: ToastGravity.BOTTOM,
                       textColor: Colors.black,
                       backgroundColor: Colors.white,
                       fontSize: 15.0
                   );
                 }
                 if(state is InterestError){
                   Fluttertoast.showToast(
                       msg: "something went wrong",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.BOTTOM,
                       textColor: Colors.black,
                       backgroundColor: Colors.white,
                       fontSize: 15.0
                   );
                 }
                 if(state is InterestsSaved){
                   Fluttertoast.showToast(
                       msg: "Interests saved successfully",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.BOTTOM,
                       textColor: Colors.black,
                       backgroundColor: Colors.white,
                       fontSize: 15.0
                   );
                   Navigator.pushNamedAndRemoveUntil(
                       context,
                       RouteName.home,
                           (route) => false);
                 }
               },
               builder: (context, state) {
                 if (state is InterestsLoading) {
                   return const Center(
                     child: CircularProgressIndicator(),
                   );
                 }
                 return LoginButtons(
                     size: size,
                     centerText: "Save interests",
                     onPressed: () {
                       BlocProvider.of<InterestsCubit>(context).saveInterest(
                           customTags: customTags,
                           userInterests: selectedInterests);
                     });
               },
             )
            ],
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               InkWell(
                 onTap: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteName.home, (route) => false);
                  },
                 child: Container(
                   padding: const EdgeInsets.all(15),
                   decoration: BoxDecoration(
                       color: themeChange.darkTheme
                           ? const Color(0xff1E1E1E):Colors.white,
                       borderRadius: BorderRadius.circular(10),
                       border: Border.all(
                         color: const Color(0xffE8ECF4),
                       )
                   ),
                   child:themeChange.darkTheme?
                   SvgPicture.asset("assets/svg/arrow_back_dark.svg"):
                   SvgPicture.asset("assets/svg/back_arrow.svg"),
                 ),
               ),
                const SizedBox(height: 10,),
                const SimpleText(
                  text: "Select your interests",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,),
                const SizedBox(height: 15,),
                BlocBuilder<GetInterestsCubit, GetInterestsState>(
                  builder: (context, state) {
                    if(state is GetInterestsLoading){
                      return Column(
                        children: [
                          SizedBox(height: size.height*0.4,),
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }
                    else if (state is GetInterestsSuccess){
                      if(onlyOnce==false){
                        items.addAll(state.listOfInterests);
                        customTags.addAll(state.customTags);
                        selectedInterests.addAll(state.selectedInterests);
                      }
                      onlyOnce=true;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffF7F8FA),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search,color: Color(0xff8391A1),),
                                const SizedBox(width: 7,),
                                Flexible(
                                  child: TextField(
                                    onChanged: (value){
                                      if(value.isEmpty){
                                        setState(() {
                                          isEmpty = false;
                                          localSearch.clear();
                                        });
                                      }else{
                                        localSearch = items
                                            .where((element) => element
                                                .toLowerCase()
                                                .contains(value.toLowerCase()))
                                            .toList();
                                        // for(int i=0; i<customTags.length;i++){
                                        //   if(customTags[i].toLowerCase().contains(value.toLowerCase())){
                                        //     localSearch.add(customTags[i]);
                                        //   }
                                        // }
                                        if (localSearch.isNotEmpty) {
                                          setState(() {
                                            isEmpty = false;
                                          });
                                        } else {
                                          setState(() {
                                            isEmpty = true;
                                          });
                                        }
                                      }
                                    },
                                    controller: search,
                                    decoration: const InputDecoration(
                                        hintText: "Search interests",
                                        border: InputBorder.none
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          localSearch.isNotEmpty || isEmpty? const SimpleText(
                            text: "Search results",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ):const SizedBox(),
                          localSearch.isNotEmpty || isEmpty
                              ? const SizedBox()
                              : const SizedBox(
                            height: 10,
                          ),
                          isEmpty
                              ? const SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0,bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SimpleText(
                                    text:
                                    "No results found",
                                    fontSize: 14,
                                    fontColor: Colors.black38,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ):Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Wrap(
                              spacing: 8.0, // horizontal spacing between items
                              runSpacing: 8.0, // vertical spacing between lines
                              children: localSearch.map((item) {
                                return InkWell(
                                  onTap: (){
                                    if(selectedInterests.contains(item)){
                                      setState(() {
                                        selectedInterests.remove(item);
                                      });
                                    }else{
                                      setState(() {
                                        selectedInterests.add(item);
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: selectedInterests.contains(item)
                                          ? const Color(0xffF6FDFF)
                                          : Colors.white,
                                      border: Border.all(
                                          color: selectedInterests.contains(item)
                                              ? const Color(0xff4EB3CA)
                                              : const Color(0xffBDC5CD),
                                          width: selectedInterests.contains(item)?2:1
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        selectedInterests.contains(item)?
                                        const Icon(
                                          Icons.close,
                                          color: Color(0xff2F2924),
                                          size: 20,
                                        )
                                            : const Icon(
                                          Icons.add,
                                          color: Color(0xff2F2924),
                                          size: 22,
                                        ),
                                        const SizedBox(width: 3,),
                                        SimpleText(
                                          text: LocalData.capitalizeFirstLetter(item),
                                          fontSize: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          localSearch.isNotEmpty || isEmpty
                              ? const SizedBox()
                              : const SizedBox(
                            height: 10,
                          ),
                          customTags.isNotEmpty? const SimpleText(
                            text: "Custom Interests",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ):const SizedBox(),
                          customTags.isEmpty
                              ? const SizedBox()
                              : const SizedBox(
                            height: 10,
                          ),
                          customTags.isNotEmpty
                              ? Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: customTags.map((item) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    customTags.remove(item);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xffBDC5CD),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SimpleText2(
                                        text: LocalData.capitalizeFirstLetter(item),
                                        fontSize: 14,
                                        fontColor: themeChange.darkTheme?Colors.black:Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.close,
                                        color: Color(0xff2F2924),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                              : const SizedBox(),
                          const SizedBox(height: 10,),
                          const SimpleText(
                            text: "Popular Interests",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 15,),
                          Wrap(
                            spacing: 8.0, // horizontal spacing between items
                            runSpacing: 8.0, // vertical spacing between lines
                            children: items.map((item) {
                              return InkWell(
                                onTap: (){
                                  if(selectedInterests.contains(item)){
                                    setState(() {
                                      selectedInterests.remove(item);
                                    });
                                  }else{
                                    setState(() {
                                      selectedInterests.add(item);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: selectedInterests.contains(item)
                                        ? const Color(0xffF6FDFF)
                                        : Colors.white,
                                    border: Border.all(
                                        color: selectedInterests.contains(item)
                                            ? const Color(0xff4EB3CA)
                                            : const Color(0xffBDC5CD),
                                        width: selectedInterests.contains(item)?2:1
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      selectedInterests.contains(item)?
                                      const Icon(
                                        Icons.close,
                                        color: Color(0xff2F2924),
                                        size: 20,
                                      )
                                          : const Icon(
                                        Icons.add,
                                        color: Color(0xff2F2924),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 3,),
                                      SimpleText2(
                                        text: LocalData.capitalizeFirstLetter(item),
                                        fontSize: 14,
                                        fontColor: themeChange.darkTheme?Colors.black:Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                    else{
                      return Column(
                        children: [
                          SizedBox(height: size.height*0.4,),
                          const Center(
                            child: SimpleText(
                              text:
                                  "Oops something went wrong please try again later",
                              textAlign: TextAlign.center,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }
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
