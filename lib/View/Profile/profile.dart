import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_bloc.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_state.dart';
import 'package:neuralcode/Models/bookmark_post_model.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import '../../Bloc/ProfileBloc/profile_event.dart';
import '../../Utils/Components/Cards/bookmark_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin{
  late TabController tabController;
  late ScrollController scrollControllerTab1;
  late ScrollController scrollControllerTab2;
  int skip = 0;
  int limit = 5;
  List<BookmarkPostModel> allPostsData = [];
  bool isLoading = false;
  bool isTab1 =true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetPostInitialEvent());
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        skip=0;
        limit=5;
        isTab1 = !isTab1;
        BlocProvider.of<ProfileBloc>(context)
            .add(TabChangeEvent(tabIndex: tabController.index));
      }
    });
    scrollControllerTab1 = ScrollController();
    scrollControllerTab2 = ScrollController();
    scrollControllerTab1.addListener(() async {
      if(allPostsData.length %5 ==0){
        if (scrollControllerTab1.position.pixels >=
            scrollControllerTab1.position.maxScrollExtent) {
          if (!isLoading) {
            isLoading=true;
            skip += 5;
            BlocProvider.of<ProfileBloc>(context).add(
              PaginationEvent(
                  limit: limit,
                  skip: skip,
                  allPrevPostData: allPostsData,
                  tab: 0
              ),
            );
            isLoading=false;
          }
      }
      }
    });
    scrollControllerTab2.addListener(() {
      if (scrollControllerTab2.position.pixels >=
          scrollControllerTab2.position.maxScrollExtent) {
        if (!isLoading) {
          isLoading = true;
          skip += 5; // Adjust according to your pagination logic
          BlocProvider.of<ProfileBloc>(context).add(
            PaginationEvent(
                limit: limit,
                skip: skip,
                allPrevPostData: allPostsData,
                tab: 1
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
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
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xffE8ECF4),
                        )
                    ),
                    child:SvgPicture.asset("assets/svg/back_arrow.svg"),
                  ),
                  const SizedBox(width: 15,),
                  const SimpleText(
                    text: "Profile",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xffE8ECF4),
                      )
                    ),
                    child: const SimpleText(
                      text: "Edit Profile",
                      fontColor: Color(0xff4EB3CA),
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleText(text: "Hemraj Chhaidwal", fontSize: 17,
                        fontColor: Colors.black,fontWeight: FontWeight.w600,),
                      SimpleText(text: "@hemraj1", fontSize: 17,
                        fontColor: Color(0xff8698A9),fontWeight: FontWeight.w600,),
                    ],
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/images/profile_pic.png"),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: TabBar(
                controller: tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: const Color(0xff4EB3CA),
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                unselectedLabelStyle: const TextStyle(color: Color(0xff8698A9)),
                labelColor: Colors.black,
                tabs: const [
                  Tab(
                      child: SimpleText(
                        text: 'Bookmark',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )),
                  Tab(
                      child: SimpleText(
                        text: 'Likes',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is GetPostLoadingState) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                else if(state is GetPostSuccessState){
                  allPostsData.clear();
                  final data = state.listOfPosts;
                  allPostsData.addAll(data);
                  return Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            BookmarkPostCard(
                              data: data,
                              scrollController: scrollControllerTab1,
                              isLoading: isLoading,
                              isTab1: isTab1,
                            ),
                            BookmarkPostCard(
                              data: data,
                              scrollController: scrollControllerTab2,
                              isLoading: isLoading,
                              isTab1: isTab1,
                            ),
                          ],
                        ),
                      ));
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
            )
          ],
        ),
      ),
    );
  }
}

