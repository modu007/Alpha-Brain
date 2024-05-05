import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_bloc.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_event.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_state.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/Components/Buttons/back_buttons_text.dart';
import '../../Utils/Components/Text/simple_text.dart';

class NotificationPost extends StatefulWidget {
  final String postId;
  const NotificationPost({super.key, required this.postId});

  @override
  State<NotificationPost> createState() => _NotificationPostState();
}

class _NotificationPostState extends State<NotificationPost> {
  @override
  void initState() {
    BlocProvider.of<NotificationPostBloc>(context)
        .add(GetPostInitialEvent(postId: widget.postId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            child: BlocConsumer<NotificationPostBloc, NotificationPostState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is NotificationPostLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationPostSuccess) {
                  bool emojiTypeBool = false;
                  var emojiType = "";
                  bool bookmarkOrNot = false;
                  if (state.listOfPosts.myBookmark!.isNotEmpty){
                    bookmarkOrNot = true;
                  } else {
                    bookmarkOrNot = false;
                  }
                  if (state.listOfPosts.myEmojis!.isNotEmpty) {
                    emojiType = state.listOfPosts.myEmojis?[0]["emoji"];
                    emojiTypeBool = true;
                  } else {
                    emojiType = "";
                    emojiTypeBool = false;
                  }
                  return Column(
                    children: [
                      BackButtonText(
                        titleText: "Z-Alpha Brain",
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed(RouteName.home);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  height: 210,
                                  child: Column(
                                    children: [
                                      state.listOfPosts.imageUrl == null
                                          ? Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                  child: Image.asset(
                                                      "assets/images/logo.png")),
                                            )
                                          : Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(state
                                                        .listOfPosts.imageUrl!),
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 15,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      border: Border.all(
                                          color: const Color(0xffCDC8BC)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(
                                            state.listOfPosts.newsUrl))) {
                                          throw Exception(
                                              'Could not launch url');
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image.asset(
                                                  "assets/images/logo.png"),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          const SimpleText(
                                            text: "Alpha Brain",
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            textHeight: 1,
                                            fontColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  emojiTypeBool
                                      ? InkWell(
                                          onTap: () {
                                            BlocProvider.of<NotificationPostBloc>(context).add(
                                              PostLikeEvent(
                                                  postData: state.listOfPosts,
                                                  previousEmojiType: emojiType,
                                                  emojisType: "",
                                                  ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svg/like_filled.svg",
                                              ),
                                            ],
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            BlocProvider.of<NotificationPostBloc>(context).add(
                                              PostLikeEvent(
                                                postData: state.listOfPosts,
                                                previousEmojiType: emojiType,
                                                emojisType: "love",
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svg/like.svg",
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      bookmarkOrNot = !bookmarkOrNot;
                                      BlocProvider.of<NotificationPostBloc>(context).add(
                                          BookmarkPostEvent(
                                              postData: state.listOfPosts,
                                              bookmark: bookmarkOrNot,
                                          ));
                                    },
                                    child: bookmarkOrNot
                                        ? SvgPicture.asset(
                                            "assets/svg/bookmarked.svg")
                                        : SvgPicture.asset(
                                            "assets/svg/bookmark.svg"),
                                  ),
                                  const Spacer(),
                                  // Container(
                                  //   padding: const EdgeInsets.all(6),
                                  //   decoration: BoxDecoration(
                                  //       shape: BoxShape.circle,
                                  //       border: Border.all(
                                  //           color: const Color(0xffD8D8D8))),
                                  //   child: SvgPicture.asset(
                                  //       "assets/svg/translate.svg"),
                                  // )
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color(0xffE8ECF4),
                            ),
                            SimpleText(
                              text: state.language==true &&  state.listOfPosts.summaryHi!= null ?
                              state.listOfPosts.summaryHi!.title
                                  : state.listOfPosts.summary.title,
                              fontSize: 17.5,
                              fontWeight: FontWeight.w400,
                              fontColor: const Color(0xff002D42),
                              textHeight: 1,
                            ),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                state.language==true &&  state.listOfPosts.summaryHi!= null ?
                                    state.listOfPosts.summaryHi?.keyPoints.length:
                                state.listOfPosts.summary.keyPoints.length,
                                itemBuilder: (context, keyIndex) {
                                  var keyPoints =
                                  state.language==true &&  state.listOfPosts.summaryHi!= null ?
                                  state.listOfPosts.summaryHi?.keyPoints[keyIndex]
                                  :state.listOfPosts.summary.keyPoints[keyIndex];
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${keyPoints?.subHeading} ",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color: const Color(0xff2B2B2B),
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: keyPoints?.description,
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color: const Color(0xff2B2B2B),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              color: Color(0xffE8ECF4),
                            ),
                            InkWell(
                              onTap: () async {
                                if (!await launchUrl(
                                    Uri.parse(state.listOfPosts.newsUrl))) {
                                  throw Exception('Could not launch url');
                                }
                              },
                              child: Row(
                                children: [
                                  const SimpleText(
                                    text: "source:",
                                    fontSize: 10,
                                    fontColor: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 2,),
                                  InkWell(
                                    child: SimpleText(
                                      text: state.listOfPosts.source,
                                      fontSize: 10,
                                      fontColor: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      )
                    ],
                  );
                } else if (state is NotificationPostError) {
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
        ),
      ),
    );
  }
}
