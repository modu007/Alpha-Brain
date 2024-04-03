import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Bloc/HomeBloc/home_bloc.dart';
import '../../../Bloc/HomeBloc/home_event.dart';
import '../../../Models/for_you_model.dart';
import '../Text/simple_text.dart';

class PostListView extends StatelessWidget {
  const PostListView({
    super.key,
    required this.data,
    required this.scrollController,
    required this.isAdmin,
    required this.selectedTag,
  });

  final List<ForYouModel> data;
  final ScrollController scrollController;
  final bool isAdmin;
  final String selectedTag;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
          separatorBuilder: (context, child) => const Divider(
            height: 1,
          ),
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (context, index) {
            if (index == data.length - 1) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else {
              bool emojiTypeBool = false;
              var emojiType = "";
              bool bookmarkOrNot = false;
              if (data[index].myBookmark!.isNotEmpty) {
                bookmarkOrNot = true;
              } else {
                bookmarkOrNot = false;
              }
              if (data[index].myEmojis!.isNotEmpty) {
                emojiType = data[index].myEmojis?[0]["emoji"];
                emojiTypeBool = true;
              } else {
                emojiType = "";
                emojiTypeBool = false;
              }
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Stack(
                      children: [
                        SizedBox(
                          height: 210,
                          child: Column(
                            children: [
                              data[index].imageUrl == null
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
                                                data[index].imageUrl!),
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
                              border: Border.all(color: const Color(0xffCDC8BC)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () async {
                                if (!await launchUrl(
                                    Uri.parse(data[index].newsUrl))) {
                                  throw Exception('Could not launch url');
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset("assets/images/logo.png"),
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
                              BlocProvider.of<HomeBloc>(context).add(
                                PostLikeEvent(
                                    postData: data[index],
                                    previousEmojiType: emojiType,
                                    emojisType: "",
                                    listOfData: data,
                                    selectedTag: selectedTag),
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
                                data[index].love != null
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 6),
                                  child: SimpleText(
                                    text: data[index]
                                        .love
                                        .toString(),
                                    fontSize: 12,
                                    fontColor:
                                    const Color(0xff060606),
                                  ),
                                )
                                    : const SizedBox()
                              ],
                            ),
                          )
                              : InkWell(
                            onTap: () {
                              BlocProvider.of<HomeBloc>(context).add(
                                  PostLikeEvent(
                                      postData: data[index],
                                      previousEmojiType: emojiType,
                                      emojisType: "love",
                                      listOfData: data,
                                      selectedTag: selectedTag));
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
                                data[index].love != null
                                    ? const SizedBox(
                                  width: 5,
                                )
                                    : const SizedBox(),
                                SimpleText(
                                  text: data[index].love != null
                                      ? data[index].love.toString()
                                      : "",
                                  fontSize: 12,
                                  fontColor: const Color(0xff060606),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              bookmarkOrNot = !bookmarkOrNot;
                              BlocProvider.of<HomeBloc>(context).add(
                                  BookmarkPostEvent(
                                      postData: data[index],
                                      listOfData: data,
                                      bookmark: bookmarkOrNot,
                                      selectedTag: selectedTag));
                            },
                            child: bookmarkOrNot
                                ? SvgPicture.asset(
                                "assets/svg/bookmarked.svg")
                                : SvgPicture.asset(
                                "assets/svg/bookmark.svg"),
                          ),
                          const Spacer(),
                          isAdmin
                              ? InkWell(
                              onTap: () {
                                BlocProvider.of<HomeBloc>(context).add(
                                    AdminActionEvent(
                                        postData: data[index],
                                        listOfData: data,
                                        selectedTag: selectedTag));
                              },
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ))
                              : const SizedBox(),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xffD8D8D8)
                              )
                            ),
                            child: SvgPicture.asset("assets/svg/translate.svg"),
                          )
                          // SleekCircularSlider(
                          //   innerWidget: (double value) {
                          //     return const Center(
                          //       child: Icon(
                          //         Icons.play_arrow_rounded,
                          //         color: Colors.black,
                          //         size: 24,
                          //       ),
                          //     );
                          //   },
                          //   appearance: CircularSliderAppearance(
                          //     spinnerMode: false,
                          //     size: 40,
                          //     startAngle: 150,
                          //     angleRange: 240,
                          //     counterClockwise: false,
                          //     customColors: CustomSliderColors(
                          //       progressBarColors: [ColorClass.backgroundColor],
                          //       hideShadow: false,
                          //     ),
                          //     customWidths: CustomSliderWidths(
                          //       progressBarWidth: 1,
                          //     ),
                          //   ),
                          //   min: 0,
                          //   max: 100,
                          //   initialValue: 70,
                          // )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xffE8ECF4),
                    ),
                    SimpleText(
                      text: data[index].summary.title,
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
                        itemCount: data[index].summary.keyPoints.length,
                        itemBuilder: (context, keyIndex) {
                          var keyPoints = data[index].summary.keyPoints[keyIndex];
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
                    const Divider(
                      color: Color(0xffE8ECF4),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!await launchUrl(
                            Uri.parse(data[index].newsUrl))) {
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
                              text: data[index].source,
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
              );
            }}),
    );
  }
}
