import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neuralcode/Bloc/AuthBloc/UploadProfileCubit/upload_image_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/UploadProfileCubit/upload_image_state.dart';
import 'package:neuralcode/Bloc/AuthBloc/UserDetailsBloc/user_details_cubit.dart';
import 'package:neuralcode/Bloc/AuthBloc/UserDetailsBloc/user_details_state.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_bloc.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_state.dart';
import 'package:neuralcode/Models/bookmark_post_model.dart';
import 'package:neuralcode/Utils/Color/colors.dart';
import 'package:neuralcode/Utils/Components/Buttons/back_buttons_text.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:provider/provider.dart';
import '../../Bloc/ProfileBloc/profile_event.dart';
import '../../Provider/dark_theme_controller.dart';
import '../../Utils/Components/Cards/bookmark_card.dart';
import '../../Utils/Routes/route_name.dart';
import 'dart:io';


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
  // using tab1 for removing bookmark or liked
  bool isTab1 =true;
  bool isEmptyData = false;
  String name = "";
  String imageUrl="";
  String dp="";
  String userName="";
  
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserDetailsCubit>(context).getUserDetails();
    BlocProvider.of<ProfileBloc>(context).add(GetPostInitialEvent());
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        skip=0;
        limit=5;
        isTab1 = !isTab1;
        isEmptyData=false;
        isLoading=false;
        BlocProvider.of<ProfileBloc>(context)
            .add(TabChangeEvent(tabIndex: tabController.index));
      }
    });
    scrollControllerTab1 = ScrollController();
    scrollControllerTab2 = ScrollController();
    scrollControllerTab1.addListener(() {
      if(!isEmptyData){
        if (scrollControllerTab1.position.pixels >=
            scrollControllerTab1.position.maxScrollExtent) {
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
            isLoading=false;
          }
        }
      }
    });
    scrollControllerTab2.addListener(() async {
     if(!isEmptyData){
       if (scrollControllerTab2.position.pixels >=
           scrollControllerTab2.position.maxScrollExtent) {
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            if(state is UserDetailsLoadingState){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(state is UserDetailsSuccessState){
              dp = state.profilePic;
              imageUrl = state.imageUrl;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: Row(
                      children: [
                         BackButtonText(
                          titleText: "Profile",
                          onPressed: () {
                           Navigator.of(context).pop();
                          },),
                        const Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pushNamed(
                                RouteName.editProfile,arguments: {
                                  "name":state.name
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xffE8ECF4),
                                )
                            ),
                            child:  SimpleText(
                              text: "Edit Profile",
                              fontColor: themeChange.darkTheme?
                                  const Color(0xff4EB3CA):
                              const Color(0xff4EB3CA),
                              fontSize: 14,
                            ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SimpleText(text: state.name, fontSize: 17,
                              fontColor: Colors.black,fontWeight: FontWeight.w600,),
                            SimpleText(text: "@${state.userName}", fontSize: 17,
                              fontColor: const Color(0xff8698A9),
                              fontWeight: FontWeight.w600,),
                          ],
                        ),
                        const Spacer(),
                        Stack(
                          children: [
                            BlocConsumer<UploadImageCubit, UploadImageState>(
                              listener: (context, state) {
                                if(state is CouldNotUploadImageState){
                                  Fluttertoast.showToast(
                                      msg: "Please try again later",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.black,
                                      fontSize: 15.0
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is UploadProfileLoadingState) {
                                  return const Center(
                                    child: CircularProgressIndicator(),);
                                }
                                if (state is UploadProfileSuccessState) {
                                  var data = state.path;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: data != null
                                        ? Image.file(
                                      File(data),
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    )
                                        : dp.isEmpty ?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/svg/user_icon.svg",
                                          height: 90,
                                          width: 90,),
                                      ),
                                    ) :
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        height: 90,
                                        width: 90,
                                        imageUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                } else {
                                  return dp.isEmpty ?
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/svg/user_icon.svg",
                                        height: 90,
                                        width: 90,),
                                    ),
                                  ) :
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      imageUrl, height: 90,
                                      width: 90,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }
                              }
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: (){
                                  BlocProvider.of<UploadImageCubit>(context)
                                      .uploadPhotoEvent();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: const Color(0xffE8ECF4),
                                        width: 2
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
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
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                      indicatorColor: const Color(0xff4EB3CA),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      unselectedLabelStyle: const TextStyle(color: Color(0xff8698A9)),
                      labelColor: Colors.black,
                      tabs: const [
                        Tab(
                            child: SimpleText(
                              text: 'Likes',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                        Tab(
                            child: SimpleText(
                              text: 'Bookmark',
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
                      print(state);
                      if (state is GetPostLoadingState) {
                        return const Expanded(
                            child: Center(child: CircularProgressIndicator()));
                      }
                      else if(state is GetPostSuccessState){
                        allPostsData.clear();
                        final data = state.listOfPosts;
                        if(state.listOfFutureData !=null && state.listOfFutureData!.isEmpty){
                          isEmptyData=true;
                        }
                        allPostsData.addAll(data);
                        return Expanded(
                            child: DefaultTabController(
                              length: 2,
                              child: TabBarView(
                                controller: tabController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  data.isEmpty ?
                                  const Center(
                                    child: SimpleText(
                                      text: 'You do not have any likes yet',
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                    ),):
                                  BookmarkPostCard(
                                    data: data,
                                    scrollController: scrollControllerTab1,
                                    isLoading: isLoading,
                                    isTab1: isTab1,
                                    futureData: state.listOfFutureData,
                                    isDataEmpty: isEmptyData,
                                    isDarkMode: themeChange.darkTheme,
                                    language: state.language,
                                  ),
                                  data.isEmpty ?
                                  const Center(
                                    child: SimpleText(
                                      text: 'You do not have any bookmarks yet',
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                    ),):
                                  data.isEmpty?
                                  const Center(
                                    child: SimpleText(
                                      text: 'You do not have any bookmarks yet',
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                    ),):
                                  BookmarkPostCard(
                                    data: data,
                                    scrollController: scrollControllerTab2,
                                    isLoading: isLoading,
                                    isTab1: isTab1,
                                    futureData: state.listOfFutureData,
                                    isDataEmpty: isEmptyData,
                                    isDarkMode: themeChange.darkTheme,
                                    language: state.language,
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
                  ),
                ],
              );
            }
            else{
              return const Center(
                child: SimpleText(
                  text: "Something went wrong",
                  fontColor: Colors.black,
                  fontSize: 16,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}



