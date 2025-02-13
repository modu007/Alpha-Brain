import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_event.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_state.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text3.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:provider/provider.dart';
import '../../Api/all_api.dart';
import '../../Bloc/HomeBloc/home_bloc.dart';
import '../../Models/for_you_model.dart';
import '../../Provider/dark_theme_controller.dart';
import '../../Utils/Components/AppBar/app_bar.dart';
import '../../Utils/Components/Cards/post_card.dart';
import '../../Utils/Components/Text/simple_text2.dart';
import '../../Utils/Data/local_data.dart';
import '../../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController scrollControllerTab1;
  TextEditingController languageController= TextEditingController();
  late StreamSubscription<String> pathSubscription;
  int skip = 0;
  int limit = 5;
  List<ForYouModel> allPostsData = [];
  bool isLoading = false;
  String name = "";
  String imageUrl="";
  String dp="";
  String selectedTag ="For you";
  bool isEmptyData = false;
  bool isVisible=true;
  List<ForYouModel> dataForLanguage=[];
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool isListened=false;
  Future getName()async{
    String result = await SharedData.getEmail("name");
    name =result;
    bool? language = await SharedData.getToken("language");
    if(language == null) {
      languageController.text= "English";
    }
    else{
      setState(() {
        languageController.text= language==true? "Hindi":"English";
      });
    }
  }
  Future getImage()async{
    String name = await SharedData.getEmail("name");
    String profilePic = await SharedData.getEmail("profilePic");
    dp = profilePic;
    imageUrl = "${AllApi.getProfilePic}$name/$profilePic";
  }
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(
        GetHomePostInitialEvent(
            selectedTag: selectedTag));
    pathSubscription = pathStreamController.stream.listen((postId) {
      if (postId.isNotEmpty) {
        isListened=true;
        isPathStreamControllerListened ="";
        navigatorKey.currentState?.pushNamed(
            RouteName.notificationPost, arguments: {
          "postId": postId,
          "fromBackground":false
        });
      }
    });
    if(isListened ==false && isPathStreamControllerListened.isNotEmpty){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamed(RouteName.notificationPost, arguments: {
          "postId": isPathStreamControllerListened,
          "fromBackground":true
        });
        isPathStreamControllerListened ="";
      });
    }
    getName();
    getImage();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        skip=0;
        limit=5;
        isEmptyData=false;
        BlocProvider.of<HomeBloc>(context)
            .add(TabChangeEvent(
            tabIndex: _tabController.index,
            selectedTag: selectedTag
        ));
      }
    });
    scrollControllerTab1 = ScrollController();
    scrollControllerTab1.addListener(() async {
      if(!isEmptyData && selectedTag=="For you"){
      if (scrollControllerTab1.position.pixels >=
          scrollControllerTab1.position.maxScrollExtent) {
        if (!isLoading) {
          isLoading = true;
          skip += 5;
         if(selectedTag == "For you"){
           BlocProvider.of<HomeBloc>(context).add(
               PaginationEvent(
                   limit: limit,
                   skip: skip,
                   allPrevPostData: allPostsData,
                   selectedTag: selectedTag,
                   tab: 0
               ));
         }
          isLoading = false;
        }
      }
    }
      else if(!isEmptyData && selectedTag == "Top Picks"){
        if (scrollControllerTab1.position.pixels >=
            scrollControllerTab1.position.maxScrollExtent) {
          if (!isLoading) {
            isLoading = true;
            skip += 5; // Adjust according to your pagination logic
            BlocProvider.of<HomeBloc>(context).add(
              PaginationEvent(
                  limit: limit,
                  skip: skip,
                  allPrevPostData: allPostsData,
                  tab: 1,
                  selectedTag: selectedTag
              ),
            );
            isLoading = false;
          }
        }
      }
      else if(!isEmptyData && selectedTag=="CT Feed" ){
        if (scrollControllerTab1.position.pixels >=
            scrollControllerTab1.position.maxScrollExtent) {
          if (!isLoading) {
            isLoading = true;
            skip += 5;
            BlocProvider.of<HomeBloc>(context).add(
                PaginationEvent(
                    limit: limit,
                    skip: skip,
                    allPrevPostData: allPostsData,
                    selectedTag: selectedTag,
                    tab: 3
                ));
            isLoading = false;
          }
        }
      }
      else{
        if (scrollControllerTab1.position.pixels >=
            scrollControllerTab1.position.maxScrollExtent) {
          if (!isLoading) {
            isLoading = true;
            skip += 5;
            BlocProvider.of<HomeBloc>(context).add(
                PaginationEvent(
                    limit: limit,
                    skip: skip,
                    allPrevPostData: allPostsData,
                    selectedTag: selectedTag,
                    tab: 2
                ));
            isLoading = false;
          }
        }
      }
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    scrollControllerTab1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        endDrawer:  Drawer(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    dp.isEmpty ?
                    SvgPicture.asset(
                      "assets/svg/user_icon.svg",height: 40,width: 40,):
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(imageUrl,height: 40,width: 40,)
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimpleText2(
                          text: name,
                          fontSize: 15,
                          fontWeight:FontWeight.w600,
                          fontColor: themeChange.darkTheme?
                          const Color(0xffafafaf): Colors.black,
                          textHeight: 0,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                ListTile(
                  leading:themeChange.darkTheme==false?
                  SvgPicture.asset("assets/svg/user_icon.svg"):
                  SvgPicture.asset("assets/svg/user_profile_dark.svg"),
                  title:SimpleText2(
                    text: 'Profile',
                    fontSize: 15,
                    fontColor: themeChange.darkTheme?
                    const Color(0xffafafaf): Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(RouteName.profile);
                  },
                ),
                ListTile(
                  leading:themeChange.darkTheme==false?
                  SvgPicture.asset("assets/svg/call.svg"):
                  SvgPicture.asset("assets/svg/call_dark.svg"),
                  title:SimpleText2(
                    text: 'Support',
                    fontSize: 15,
                    fontColor: themeChange.darkTheme?
                    const Color(0xffafafaf): Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: (){
                    Navigator.of(context).pushNamed(RouteName.support);
                  },
                ),
                ListTile(
                  leading:themeChange.darkTheme==false?
                  SvgPicture.asset("assets/svg/logout.svg"):
                  SvgPicture.asset("assets/svg/logout.svg",
                    color: const Color(0xffafafaf),),
                  title:   SimpleText2(
                    text: 'Logout',
                    fontSize: 15,
                    fontColor: themeChange.darkTheme?
                    const Color(0xffafafaf): Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: (){
                    SharedData.removeUserid("token");
                    SharedData.removeUserid("refresh");
                    SharedData.removeUserid("email");
                    SharedData.removeUserid("username");
                    SharedData.removeUserid("name");
                    SharedData.removeUserid("profilePic");
                    SharedData.removeUserid("custom");
                    SharedData.removeUserid("interests");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteName.signIn, (route) => false);
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Divider(
                            color: Color(0xffD1D3D4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0,left: 10,right: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svg/globe.svg"),
                              const SizedBox(width: 5,),
                              const SimpleText(text: "Language", fontSize: 15,
                                fontColor: Color(0xff060606),),
                              const Spacer(),
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  icon: SvgPicture.asset("assets/svg/drop_down.svg"),
                                  value: languageController.text.isEmpty
                                      ? null
                                      : languageController.text,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        languageController.text = newValue;
                                      });
                                      BlocProvider.of<HomeBloc>(context)
                                          .add(LanguageChange(
                                        listOfFutureData: null,
                                          language:
                                          languageController.text ==
                                              "English"
                                              ? false
                                              : true,
                                          listOfPost: allPostsData,
                                          selectedTag: selectedTag));
                                    }
                                  },
                                  items: ['English', 'Hindi']
                                      .map<DropdownMenuItem<String>>(
                                        (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  ).toList(),
                                  style: const TextStyle(
                                      color: Color(0xff4EB3CA),
                                      fontSize: 17
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Language",
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.besley(
                                      color: const Color(0xff4EB3CA),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(4),
                          decoration:  BoxDecoration(
                            color:themeChange.darkTheme?
                            const Color(0xff2F2F2F):
                            const Color(0xffF0F0F0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    if(themeChange.darkTheme==true){
                                      themeChange.setDarkTheme=false;
                                      darkThemePreference.setDarkTheme(false);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10,vertical: 5),
                                    decoration:  BoxDecoration(
                                      color: themeChange.darkTheme ?
                                      const Color(0xff2F2F2F) :
                                      Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        themeChange.darkTheme?
                                        SvgPicture.asset("assets/svg/sun_dark.svg"):
                                        SvgPicture.asset("assets/svg/sun.svg"),
                                        const SizedBox(width: 8,),
                                        SimpleText2(
                                          text: "Light",
                                          fontSize: 16,
                                          fontColor: themeChange.darkTheme?
                                          Colors.white:Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    if(themeChange.darkTheme==false){
                                      themeChange.setDarkTheme=true;
                                      darkThemePreference.setDarkTheme(true);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10,vertical: 5),
                                    decoration:  BoxDecoration(
                                      color:themeChange.darkTheme==true ?
                                      const Color(0xff474747) :const Color(0xffF0F0F0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        themeChange.darkTheme?
                                        SvgPicture.asset("assets/svg/moon_dark.svg"):
                                        SvgPicture.asset("assets/svg/moon.svg"),
                                        const SizedBox(width: 8,),
                                        SimpleText2(
                                          text: "Dark",
                                          fontSize: 16,
                                          fontColor: themeChange.darkTheme?
                                          Colors.white:Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            HomeAppBar(
              darkTheme: themeChange.darkTheme,
              // isVisibleWhenScroll: isVisible,
              tabController: _tabController,
              widget: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap:(){
                              if(selectedTag!="For you"){
                                setState(() {
                                  selectedTag="For you";
                                });
                                skip=0;
                                limit=5;
                                BlocProvider.of<HomeBloc>(context)
                                    .add(TabChangeEvent(
                                    tabIndex: 0,
                                    selectedTag: selectedTag
                                ));
                                isEmptyData = false;
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  selectedTag == "For you" ? 10 : 4,
                                  vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedTag=="For you" ? const Color(0xffCCEAF4) :
                                themeChange.darkTheme?
                                const Color(0xff121212):
                                Colors.white,
                              ),
                              child: themeChange.darkTheme
                                  ? SimpleText3(
                                text: "For you",
                                fontSize: 14,
                                fontColor:
                                selectedTag == "For you"
                                    ? Colors.black87
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                              )
                                  : const SimpleText(
                                text: "For you",
                                fontSize: 14,
                                fontColor: Color(0xff56626c),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          LocalData.getCustomTags.isNotEmpty?
                          InkWell(
                            onTap:(){
                              if(selectedTag!="CT Feed"){
                                setState(() {
                                  selectedTag="CT Feed";
                                });
                                skip=0;
                                limit=5;
                                BlocProvider.of<HomeBloc>(context)
                                    .add(TabChangeEvent(
                                    tabIndex: 2,
                                    selectedTag: selectedTag
                                ));
                                isEmptyData = false;
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  selectedTag == "CT Feed" ? 10 : 4,
                                  vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedTag=="CT Feed" ? const Color(0xffCCEAF4) :
                                themeChange.darkTheme?
                                const Color(0xff121212):
                                Colors.white,
                              ),
                              child: themeChange.darkTheme?
                              SimpleText3(
                                text: "CT Feed",
                                fontSize: 14,
                                fontColor:selectedTag=="CT Feed"?
                                Colors.black87 :  Colors.white,
                                fontWeight: FontWeight.w500,
                              ): const SimpleText(
                                text: "CT Feed",
                                fontSize: 14,
                                fontColor: Color(0xff56626c),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ):const SizedBox(),
                          Container(
                            color: themeChange.darkTheme
                                ? const Color(0xff121212)
                                : Colors.white,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                children: LocalData.getUserInterestsSelected.map((tag) {
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        selectedTag=tag;
                                      });
                                      BlocProvider.of<HomeBloc>(context).add(
                                          TagSelectedEvent(
                                              selectedTag: tag,
                                              tabIndex: _tabController.index
                                          )
                                      );
                                      isEmptyData = false;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      padding: EdgeInsets.symmetric(horizontal:selectedTag==tag? 10:4, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: selectedTag==tag ? const Color(0xffCCEAF4) :
                                        themeChange.darkTheme?
                                        const Color(0xff121212):
                                        Colors.white,
                                      ),
                                      child:themeChange.darkTheme?
                                      SimpleText3(
                                        text: LocalData.capitalizeFirstLetter(tag),
                                        fontSize: 14,
                                        fontColor:selectedTag==tag?
                                        Colors.black87 :  Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ): SimpleText(
                                        text:  LocalData.capitalizeFirstLetter(tag),
                                        fontSize: 14,
                                        fontColor: const Color(0xff56626c),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          LocalData.getUserInterestsSelected.isEmpty?
                          Container(
                            color: themeChange.darkTheme
                                ? const Color(0xff121212)
                                : Colors.white,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                children: LocalData.getInterests.map((tag) {
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        selectedTag=tag;
                                      });
                                      BlocProvider.of<HomeBloc>(context).add(
                                          TagSelectedEvent(
                                              selectedTag: tag,
                                              tabIndex: _tabController.index
                                          )
                                      );
                                      isEmptyData = false;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      padding: EdgeInsets.symmetric(horizontal:selectedTag==tag? 10:4, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: selectedTag==tag ? const Color(0xffCCEAF4) :
                                        themeChange.darkTheme?
                                        const Color(0xff121212):
                                        Colors.white,
                                      ),
                                      child:themeChange.darkTheme?
                                      SimpleText3(
                                        text: LocalData.capitalizeFirstLetter(tag),
                                        fontSize: 14,
                                        fontColor:selectedTag==tag?
                                        Colors.black87 :  Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ): SimpleText(
                                        text:  LocalData.capitalizeFirstLetter(tag),
                                        fontSize: 14,
                                        fontColor: const Color(0xff56626c),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ):const SizedBox()
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(RouteName.interests);
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 15,),
                        SvgPicture.asset("assets/svg/filter.svg",width: 20,height: 18,)
                      ],
                    ),
                  )
                ],
              ),
            ),
            BlocConsumer<HomeBloc, HomeState>(
              listenWhen: (previous, current) => current is HomeActionState,
              buildWhen: (previous, current) => current is! HomeActionState,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is GetPostLoadingState) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
                else if (state is GetPostSuccessState) {
                  final List<ForYouModel> data = [];
                  data.addAll(state.listOfPosts);
                  allPostsData.clear();
                  allPostsData.addAll(data);
                  if(state.listOfFutureData !=null && state.listOfFutureData!.isEmpty){
                    isEmptyData=true;
                  }
                  return Expanded(
                    child: PostListView(
                      data: data,
                      scrollController: scrollControllerTab1,
                      isAdmin: state.isAdmin,
                      selectedTag: selectedTag,
                      isDarkMode: themeChange.darkTheme,
                      language: state.languageChange,
                      listOfFutureData: state.listOfFutureData,
                      isEmpty: isEmptyData,
                    ),
                  );
                }
                else if (state is GetPostFailureState) {
                  return Center(
                    child: SimpleText(
                      text: state.errorMessage,
                      fontSize: 16,
                    ),
                  );
                } else {
                  return const Center(
                    child: SimpleText(
                      text: "Loading...",
                      fontSize: 16,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}