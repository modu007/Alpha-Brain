import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_event.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_state.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import 'package:neuralcode/Utils/Components/AppBar/app_bar.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:neuralcode/Utils/Data/local_data.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import '../../Api/all_api.dart';
import '../../Bloc/HomeBloc/home_bloc.dart';
import '../../Models/for_you_model.dart';
import '../../Utils/Components/Cards/post_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FA),
        endDrawer:  Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
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
                      SimpleText(
                        text: name,
                        fontSize: 15,
                        fontWeight:FontWeight.w600,
                        fontColor: Colors.black,
                        textHeight: 0,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20,),
              ListTile(
                leading: SvgPicture.asset("assets/svg/user_icon.svg"),
                title:  const SimpleText(
                  text: 'Profile',
                  fontSize: 15,
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(RouteName.profile);
                },
              ),
              ListTile(
                leading: SvgPicture.asset("assets/svg/call.svg"),
                title:  const SimpleText(
                  text: 'Support',
                  fontSize: 15,
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onTap: (){
                  Navigator.of(context).pushNamed(RouteName.support);
                },
              ),
              ListTile(
                leading: SvgPicture.asset("assets/svg/logout.svg"),
                title:  const SimpleText(
                  text: 'Logout',
                  fontSize: 15,
                  fontColor: Colors.black,
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
            ],
          ),
        ),
        body: Column(
          children: [
            HomeAppBar(
              tabController: _tabController,
              widget: Container(
                color: Colors.white,
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
                              tabIndex: _tabController.index));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedTag==tag ?
                              const Color(0xffCCEAF4):
                              Colors.white),
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
            ),
            BlocConsumer<HomeBloc, HomeState>(
              listenWhen: (previous, current) => current is HomeActionState,
              buildWhen: (previous, current) => current is! HomeActionState,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is GetPostLoadingState) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                } else if (state is GetPostSuccessState) {
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
                          ),
                          PostListView(
                            data: data,
                            scrollController: scrollControllerTab2,
                            isAdmin: state.isAdmin,
                            selectedTag: selectedTag,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is GetPostFailureState) {
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