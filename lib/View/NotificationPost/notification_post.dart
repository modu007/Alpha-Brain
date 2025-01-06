import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_bloc.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_event.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_state.dart';
import 'package:neuralcode/Utils/Routes/route_name.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Core/AppLink/handle_app_link.dart';
import '../../Models/notification_post_model.dart';
import '../../Provider/dark_theme_controller.dart';
import '../../Repositories/HomeRepo/home_repo.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../Utils/Components/Buttons/back_buttons_text.dart';
import '../../Utils/Components/Text/simple_text.dart';
import 'package:http/http.dart' as http;


class NotificationPost extends StatefulWidget {
  final String postId;
  final bool fromBackGround;

  const NotificationPost(
      {super.key, required this.postId, required this.fromBackGround});

  @override
  State<NotificationPost> createState() => _NotificationPostState();
}

class _NotificationPostState extends State<NotificationPost> {
  String selectedTag ="For you";
  bool? language;

  Future<void> shareImageTextAndURL(
      {required NotificationPostModel postModel}) async {
    try {
      final response = await http.get(Uri.parse(postModel.imageUrl.toString()));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/shared_image.png');
        await file.writeAsBytes(bytes);
        bool? sharedLanguage = await SharedData.getToken("language");
        // Generate the link
        String myGeneratedLink =
            await DynamicLinkHandler.instance.createProductLink(id: postModel.id);
        String redirectLink=postModel.shortUrl.toString();
        if(postModel.shortUrl== null){
          redirectLink = await HomeRepo.getShortNewsUrlGenerator(
              postId: postModel.id, appUrl: myGeneratedLink);
        }
        var englishKeyPoints=postModel.summary.keyPoints[0];
        var hindiKeyPoints=postModel.summaryHi?.keyPoints[0];
        if (englishKeyPoints.description.isNotEmpty) {
          // Prepare the components
          final subHeading = sharedLanguage == false
              ? englishKeyPoints.subHeading
              : hindiKeyPoints?.subHeading;
          final desc =sharedLanguage == false
              ? englishKeyPoints.description
              : hindiKeyPoints?.description;
          final fixedText =
              '${sharedLanguage == false ? postModel.summary.title : postModel.summaryHi?.title}\n$subHeading\nCheck this out: $redirectLink';
          final fixedLength = fixedText.length;
          final availableDescLength = 232 - fixedLength;
          final truncatedDesc = desc!.length > availableDescLength
              ? '${desc.substring(0, availableDescLength - 3)}...' // -3 for the ellipsis
              : desc;
          final shareText =
              '${sharedLanguage == false ? postModel.summary.title : postModel.summaryHi?.title}\n\n$redirectLink/${sharedLanguage == false ? "en" : "hi"}';
          await Share.shareXFiles(
            [XFile(file.path)],
            text: shareText,
          );
        }
      } else {
        print('Failed to download the image.');
      }
    } catch (e) {
      print('Error sharing: $e');
    }
  }

  getLanguage()async{
    language = await SharedData.getToken("language");
    language ??= false;
    return language;
  }

  @override
  void initState() {
    BlocProvider.of<NotificationPostBloc>(context)
        .add(GetPostInitialEvent(postId: widget.postId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: PopScope(
        canPop: false,
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
                    return  Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height/2,
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                  else if (state is NotificationPostSuccess) {
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
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: BackButtonText(
                            titleText: "Ekonara",
                            onPressed: (){
                              if(widget.fromBackGround){
                                Navigator.pushNamedAndRemoveUntil(
                                    context, RouteName.home, (route) => false);
                              }else{
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: size.width,
                          margin: const EdgeInsets.only(top: 10),
                          color:themeChange.darkTheme?const Color(0xff1e1e1e):Colors.white,
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
                                            ? InkWell(
                                          onTap: ()async{
                                            if (!await launchUrl(Uri.parse(
                                                state.listOfPosts.newsUrl))) {
                                              throw Exception(
                                                  'Could not launch url');
                                            }
                                          },
                                              child: Container(
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  ),
                                                  child: Center(
                                                      child: Image.asset(
                                                          "assets/images/logo.png")),
                                                ),
                                            )
                                            : InkWell(
                                          onTap: ()async{
                                            if (!await launchUrl(Uri.parse(
                                                state.listOfPosts.newsUrl))) {
                                              throw Exception(
                                                  'Could not launch url');
                                            }
                                          },
                                              child: Container(
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
                                              text: "Ekonara",
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
                                                  height: 22,
                                                  width: 22,
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
                                                  height: 22,
                                                  width: 22,
                                                ),
                                              ],
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 15,
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
                                              "assets/svg/bookmarked.svg",  height: 22,
                                        width: 22,)
                                          : SvgPicture.asset(
                                              "assets/svg/bookmark.svg",  height: 22,
                                        width: 22,),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        shareImageTextAndURL(
                                          postModel: state.listOfPosts,);
                                      },
                                      child: SvgPicture.asset("assets/svg/share.svg"),),
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
                                fontSize: 16.5.sp,
                                fontWeight: FontWeight.w500,
                                fontColor: const Color(0xff002D42),
                                textHeight: 1,
                              ),
                              const SizedBox(height: 15,),
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
                                              text:keyPoints?.subHeading== ""? "":"${keyPoints?.subHeading} ",
                                              style: GoogleFonts.roboto(
                                                fontSize: 13.5.sp,
                                                color: themeChange.darkTheme ?
                                                Colors.white :const Color(0xff2B2B2B),
                                                fontWeight: FontWeight.w700,
                                                height: 1.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: keyPoints?.description.trim(),
                                              style: GoogleFonts.roboto(
                                                fontSize: 13.5.sp,
                                                color: themeChange.darkTheme ?
                                              Colors.white :const Color(0xff2B2B2B),
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
                  }
                  else if (state is NotificationPostError) {
                    return Center(
                      child: SimpleText(
                        text: state.errorMessage,
                        fontSize: 16,
                      ),
                    );
                  }
                  else {
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
      ),
    );
  }
}
