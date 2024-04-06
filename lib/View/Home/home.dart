import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_event.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_state.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController scrollControllerTab1;
  late ScrollController scrollControllerTab2;

  int skip = 0;
  int limit = 5;
  List<ForYouModel> allPostsData = [];
  bool isLoading = false;
  String name = "";
  String imageUrl="";
  String dp="";
  String selectedTag ="All";
  bool isVisible=true;
  Future getName()async{
    String result = await SharedData.getEmail("name");
    name =result;
    setState(() {});
  }

  Future getImage()async{
    String name = await SharedData.getEmail("name");
    String profilePic = await SharedData.getEmail("profilePic");
    dp = profilePic;
    imageUrl = "${AllApi.getProfilePic}$name/$profilePic";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getName();
    getImage();
    BlocProvider.of<HomeBloc>(context).add(
        GetPostInitialEvent(
        selectedTag: selectedTag));
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        skip=0;
        limit=5;
        BlocProvider.of<HomeBloc>(context)
            .add(TabChangeEvent(
          tabIndex: _tabController.index,
          selectedTag: selectedTag
        ));
      }
    });
    scrollControllerTab1 = ScrollController();
    scrollControllerTab2 = ScrollController();
    scrollControllerTab1.addListener(() async {
      if(scrollControllerTab1.position
          .userScrollDirection == ScrollDirection.forward && isVisible!=true
      ){
        isVisible =true;
        setState(() {});
      }else if(scrollControllerTab1.position
          .userScrollDirection == ScrollDirection.reverse && isVisible!=false){
        isVisible=false;
        setState(() {});
      }
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
                tab: 0
            ),
          );
          isLoading = false;
        }
      }
    });
    scrollControllerTab2.addListener(() {
      if (scrollControllerTab2.position.pixels >=
          scrollControllerTab2.position.maxScrollExtent) {
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
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    scrollControllerTab1.dispose();
    scrollControllerTab2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
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
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteName.signIn, (route) => false);
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
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
                                  themeChange.darkTheme=false;
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
                                  themeChange.darkTheme=true;
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
                  ),
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            AnimatedOpacity(
              opacity: isVisible ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              curve:  Curves.fastOutSlowIn,
              child: isVisible ?
              HomeAppBar(
                darkTheme: themeChange.darkTheme,
                isVisibleWhenScroll: isVisible,
                tabController: _tabController,
                widget: Container(
                        color: themeChange.darkTheme
                            ? const Color(0xff121212)
                            : Colors.white,
                        child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      children: LocalData.getTags.map((tag) {
                        return InkWell(
                          onTap: (){
                            selectedTag=tag;
                            setState(() {});
                            BlocProvider.of<HomeBloc>(context).add(
                                TagSelectedEvent(
                                    selectedTag: tag,
                                    tabIndex: _tabController.index
                                )
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedTag==tag ? const Color(0xffCCEAF4) :
                              themeChange.darkTheme?
                              const Color(0xff121212):
                              Colors.white,
                            ),
                            child: SimpleText(
                              text: tag,
                              fontSize: 15,
                              fontColor: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ):
              const SizedBox(),
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
                  allPostsData.clear();
                  final data = state.listOfPosts;
                  allPostsData.addAll(data);
                  return Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          PostListView(
                            data: data,
                            scrollController: scrollControllerTab1,
                            isAdmin: state.isAdmin,
                            selectedTag: selectedTag,
                            isDarkMode: themeChange.darkTheme,
                          ),
                          PostListView(
                            data: data,
                            scrollController: scrollControllerTab2,
                            isAdmin: state.isAdmin,
                            selectedTag: selectedTag,
                            isDarkMode: themeChange.darkTheme,
                          ),
                        ],
                      ),
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