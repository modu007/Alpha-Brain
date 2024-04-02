import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_bloc.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_event.dart';
import 'package:neuralcode/Bloc/NotificationPostBloc/notification_post_state.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/Components/Buttons/back_buttons_text.dart';
import '../../Utils/Components/Text/simple_text.dart';

class NotificationPost extends StatefulWidget {
  final ForYouModel postData;
  const NotificationPost({super.key, required this.postData});

  @override
  State<NotificationPost> createState() => _NotificationPostState();
}

class _NotificationPostState extends State<NotificationPost> {
  @override
  void initState() {
    BlocProvider.of<NotificationPostBloc>(context).add(
        GetPostInitialEvent());
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
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: SingleChildScrollView(
            child: BlocConsumer<NotificationPostBloc, NotificationPostState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if(state is NotificationPostLoading){
                return const Center(child: CircularProgressIndicator());
              }
              else if(state is NotificationPostSuccess){
                return Column(
                  children: [
                    BackButtonText(
                      titleText: "Z-Alpha Brain",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset("assets/images/logo.png"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SimpleText(
                                      text: "Alpha Brain",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      textHeight: 1,
                                    ),
                                    SimpleText(
                                      text: "@alphabrain",
                                      fontSize: 12,
                                      textHeight: 2,
                                      fontColor: Color(0xff8698A9),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                SimpleText(
                                  text: state.listOfPosts.dateTime.split("2024")[0],
                                  fontSize: 12,
                                  fontColor: const Color(0xff8698A9),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                height: 220,
                                child: Column(
                                  children: [
                                    state.listOfPosts.imageUrl == null
                                        ? Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: Image.asset(
                                              "assets/images/logo.png")),
                                    )
                                        : Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                state.listOfPosts.imageUrl!),
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
                                    color: Colors.transparent,
                                    border: Border.all(color: const Color(0xffCDC8BC)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      if (!await launchUrl(
                                          Uri.parse(state.listOfPosts.newsUrl))) {
                                        throw Exception('Could not launch url');
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            "assets/images/hindustan_times.png"),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SimpleText(
                                          text: state.listOfPosts.source,
                                          fontSize: 8,
                                          fontColor: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   bottom: 10,
                              //   left: 15,
                              //   child: Row(
                              //     children: [
                              //       Container(
                              //         padding: const EdgeInsets.all(6),
                              //         decoration: BoxDecoration(
                              //             color: Colors.white,
                              //             border: Border.all(
                              //                 color: const Color(0xffF8F8FA)),
                              //             borderRadius: BorderRadius.circular(20),
                              //             boxShadow: const [
                              //               BoxShadow(
                              //                 color: Colors.grey,
                              //                 blurRadius: 2,
                              //               )
                              //             ]),
                              //         child: emojiTypeBool
                              //             ? InkWell(
                              //           onTap: () {
                              //             // BlocProvider.of<HomeBloc>(context).add(
                              //             //   PostLikeEvent(
                              //             //       postData: state.listOfPosts,
                              //             //       previousEmojiType: emojiType,
                              //             //       emojisType: "",
                              //             //       listOfData: data,
                              //             //       selectedTag: selectedTag),
                              //             // );
                              //           },
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.min,
                              //             mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //             crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //             children: [
                              //               SvgPicture.asset(
                              //                 "assets/svg/heart_filled.svg",
                              //               ),
                              //               state.listOfPosts.love != null
                              //                   ? Padding(
                              //                 padding:
                              //                 const EdgeInsets.only(
                              //                     left: 6),
                              //                 child: SimpleText(
                              //                   text: state.listOfPosts
                              //                       .love
                              //                       .toString(),
                              //                   fontSize: 12,
                              //                   fontColor:
                              //                   const Color(0xff060606),
                              //                 ),
                              //               )
                              //                   : const SizedBox()
                              //             ],
                              //           ),
                              //         )
                              //             : InkWell(
                              //           onTap: () {
                              //             // BlocProvider.of<HomeBloc>(context).add(
                              //             //     PostLikeEvent(
                              //             //         postData: state.listOfPosts,
                              //             //         previousEmojiType: emojiType,
                              //             //         emojisType: "love",
                              //             //         listOfData: data,
                              //             //         selectedTag: selectedTag));
                              //           },
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.min,
                              //             mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //             crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //             children: [
                              //               SvgPicture.asset(
                              //                 "assets/svg/heart.svg",
                              //               ),
                              //               state.listOfPosts.love != null
                              //                   ? const SizedBox(
                              //                 width: 5,
                              //               )
                              //                   : const SizedBox(),
                              //               SimpleText(
                              //                 text: state.listOfPosts.love != null
                              //                     ? state.listOfPosts.love.toString()
                              //                     : "",
                              //                 fontSize: 12,
                              //                 fontColor: const Color(0xff060606),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         width: 10,
                              //       ),
                              //       InkWell(
                              //         onTap: () {
                              //           // bookmarkOrNot = !bookmarkOrNot;
                              //           // BlocProvider.of<HomeBloc>(context).add(
                              //           //     BookmarkPostEvent(
                              //           //         postData: state.listOfPosts,
                              //           //         listOfData: data,
                              //           //         bookmark: bookmarkOrNot,
                              //           //         selectedTag: selectedTag));
                              //         },
                              //         child: Container(
                              //           padding: const EdgeInsets.all(8),
                              //           decoration: BoxDecoration(
                              //               color: Colors.white,
                              //               border: Border.all(
                              //                   color: const Color(0xffF8F8FA)),
                              //               borderRadius: BorderRadius.circular(20),
                              //               boxShadow: const [
                              //                 BoxShadow(
                              //                   color: Colors.grey,
                              //                   blurRadius: 2,
                              //                 )
                              //               ]),
                              //           child: bookmarkOrNot
                              //               ? SvgPicture.asset(
                              //               "assets/svg/bookmarked.svg")
                              //               : SvgPicture.asset(
                              //               "assets/svg/bookmark.svg"),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                          SimpleText(
                            text: state.listOfPosts.summary.title,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontColor: const Color(0xff002D42),
                            textHeight: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.listOfPosts.summary.keyPoints.length,
                              itemBuilder: (context, keyIndex) {
                                var keyPoints = state.listOfPosts.summary.keyPoints[keyIndex];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${keyPoints.subHeading} ",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            color: const Color(0xff2B2B2B),
                                            fontWeight: FontWeight.w600,
                                            height: 1.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: keyPoints.description,
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
    );
  }
}
