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
    return ListView.builder(
        shrinkWrap: true,
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
          } else {
            bool emojiTypeBool = false;
            var emojiType = "";
            bool bookmarkOrNot = false;
            if (data[index].myBookmark!.isNotEmpty) {
              bookmarkOrNot = true;
            } else {
              bookmarkOrNot = false;
            }
            if (data[index].myEmojis.isNotEmpty) {
              emojiType = data[index].myEmojis[0]["emoji"];
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
                        isAdmin
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
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
                                      )),
                                  SimpleText(
                                    text: data[index].dateTime.split("2024")[0],
                                    fontSize: 12,
                                    fontColor: const Color(0xff8698A9),
                                  )
                                ],
                              )
                            : SimpleText(
                                text: data[index].dateTime.split("2024")[0],
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
                            color: Colors.transparent,
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
                                Image.asset(
                                    "assets/images/hindustan_times.png"),
                                const SizedBox(
                                  width: 5,
                                ),
                                SimpleText(
                                  text: data[index].source,
                                  fontSize: 8,
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 15,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffF8F8FA)),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                    )
                                  ]),
                              child: emojiTypeBool
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
                                            "assets/svg/heart_filled.svg",
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
                                            "assets/svg/heart.svg",
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
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0xffF8F8FA)),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                      )
                                    ]),
                                child: bookmarkOrNot
                                    ? SvgPicture.asset(
                                        "assets/svg/bookmarked.svg")
                                    : SvgPicture.asset(
                                        "assets/svg/bookmark.svg"),
                              ),
                            ),
                            // const Spacer(),
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
                      )
                    ],
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
                ],
              ),
            );
          }});
  }
}
