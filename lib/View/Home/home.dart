import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/home_bloc.dart';
import 'package:neuralcode/Bloc/home_event.dart';
import 'package:neuralcode/Bloc/home_state.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import 'package:neuralcode/Utils/Color/colors.dart';
import 'package:neuralcode/Utils/Components/AppBar/app_bar.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:svg_flutter/svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  late TabController _tabController;

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        backgroundColor: ColorClass.backgroundColor,
        body: Column(
          children: [
            const HomeAppBar(),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // Creates border
                  color: Colors.greenAccent,
                ),
                tabs: const [
                  Tab(
                      child: SimpleText(
                        text: 'For you',
                        fontSize: 20,)),
                  Tab(
                      child: SimpleText(
                        text: 'Top picks',
                        fontSize: 20,)),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listenWhen: (previous, current) => current is HomeActionState,
                buildWhen: (previous, current) => current is! HomeActionState,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if(state is GetPostLoadingState){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (state is GetPostSuccessState) {
                    final data = state.listOfPosts;
                    return DefaultTabController(
                      length: 2,
                      child: TabBarView(
                        children: [
                          PostListView(data: data),
                          PostListView(data: data),
                        ],
                      ),
                    );
                  }
                  else if (state is GetPostFailureState){
                    return Center(
                      child: SimpleText(
                        text: state.errorMessage,
                        fontSize: 16,),
                    );
                  }
                  else{
                    return const Center(
                      child: SimpleText(
                        text: "Loading...",
                        fontSize: 16,),
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

class PostListView extends StatelessWidget {
  const PostListView({
    super.key,
    required this.data,
  });

  final List<ForYouModel> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context,index){
          return Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10),
            padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset("assets/images/profile-1.jpg"),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    const Flexible(
                      child: SimpleText(
                        text: "Alpha Brains",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        maxLines: 2,
                        textHeight: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(data[index].imageUrl),
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset("assets/svg/heart-1.svg",),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const SimpleText(
                          text:"Ask query",
                          fontSize: 15,
                          fontColor: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SvgPicture.asset("assets/svg/bookmark.svg",),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                SimpleText(
                  text: data[index].summary.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textHeight: 1,
                ),
                const SizedBox(height: 6,),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data[index].summary.keyPoints.length,
                    itemBuilder: (context,keyIndex){
                      var keyPoints = data[index]
                          .summary.keyPoints[keyIndex];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5),
                        child: RichText(
                          text:  TextSpan(
                            children: [
                              TextSpan(
                                text: "${keyPoints.subHeading} ",
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: keyPoints.description,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 15,),
                SimpleText(
                  text: "source: ${data[index].source}",
                  fontSize: 13,fontColor: Colors.grey,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
          );
        });
  }
}
