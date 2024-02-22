import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_event.dart';
import 'package:neuralcode/Bloc/HomeBloc/home_state.dart';
import 'package:neuralcode/Utils/Components/AppBar/app_bar.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(GetPostInitialEvent());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        BlocProvider.of<HomeBloc>(context)
            .add(TabChangeEvent(tabIndex: _tabController.index));
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            HomeAppBar(tabController: _tabController,),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listenWhen: (previous, current) => current is HomeActionState,
                buildWhen: (previous, current) => current is! HomeActionState,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is GetPostLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetPostSuccessState) {
                    allPostsData.clear();
                    final data = state.listOfPosts;
                    allPostsData.addAll(data);
                    return DefaultTabController(
                      length: 2,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          PostListView(
                            data: data,
                            scrollController: scrollControllerTab1,
                          ),
                          PostListView(
                            data: data,
                            scrollController: scrollControllerTab1,
                          ),
                        ],
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
            ),
          ],
        ),
      ),
    );
  }
}
