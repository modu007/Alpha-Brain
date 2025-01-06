import 'dart:developer';
import 'dart:io';
import 'package:neuralcode/Core/AppLink/handle_app_link.dart';
import 'package:neuralcode/Repositories/HomeRepo/home_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Bloc/HomeBloc/home_bloc.dart';
import '../../../Bloc/HomeBloc/home_event.dart';
import '../../../Models/for_you_model.dart';
import '../../../SharedPrefernce/shared_pref.dart';
import '../Text/simple_text.dart';

class PostListView extends StatefulWidget {

  const PostListView({
    super.key,
    required this.data,
    required this.scrollController,
    required this.isAdmin,
    required this.selectedTag,
    required this.isDarkMode,
    required this.language,
    required this.isEmpty,
    required this.listOfFutureData,
  });

  final List<ForYouModel> data;
  final ScrollController scrollController;
  final bool isAdmin;
  final String selectedTag;
  final bool isDarkMode;
  final bool language;
  final bool isEmpty;
  final List<ForYouModel>? listOfFutureData;

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {


  Future<void> shareImageTextAndURL(
      {required ForYouModel postModel}) async {
    try {
      final response = await http.get(Uri.parse(postModel.imageUrl.toString()));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/shared_image.png');
        await file.writeAsBytes(bytes);
        // Generate the link
        String myGeneratedLink = await DynamicLinkHandler.instance.createProductLink(id: postModel.id);
        String redirectLink=postModel.shortUrl.toString();
        bool? language = await SharedData.getToken("language");
        print(language);
        if(postModel.shortUrl== null){
          print(postModel.id);
          redirectLink = await HomeRepo.getShortNewsUrlGenerator(
              postId: postModel.id, appUrl: "");
          print(redirectLink);
        }
        print("here");
        var englishKeyPoints=postModel.summary.keyPoints[0];
        var hindiKeyPoints=postModel.summaryHi?.keyPoints[0];
        if (englishKeyPoints.description.isNotEmpty) {
          final subHeading = language == false
              ? englishKeyPoints.subHeading
              : hindiKeyPoints?.subHeading;
          final desc =language == false
              ? englishKeyPoints.description
              : hindiKeyPoints?.description;
          final fixedText =
              '${language == false ? postModel.summary.title : postModel.summaryHi?.title}\n$subHeading\nCheck this out: $redirectLink';
          final fixedLength = fixedText.length;
          final availableDescLength = 232 - fixedLength;
          final truncatedDesc = desc!.length > availableDescLength
              ? '${desc.substring(0, availableDescLength - 3)}...' // -3 for the ellipsis
              : desc;
          final shareText =
              '${language == false ? postModel.summary.title : postModel.summaryHi?.title}\n\n$redirectLink/${language == false ? "en" : "hi"}';
          await Share.shareXFiles(
            [XFile(file.path)],
            text: shareText,
          );
        }
      } else {
        log("something went wrong");
      }
    } catch (e) {
      log('Error sharing: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          controller: widget.scrollController,
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            if (index == widget.data.length-1 && widget.isEmpty==false) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else {
              bool translateHindi=widget.language;
              bool emojiTypeBool = false;
              var emojiType = "";
              bool bookmarkOrNot = false;
              if (widget.data[index].myBookmark!.isNotEmpty) {
                bookmarkOrNot = true;
              } else {
                bookmarkOrNot = false;
              }
              if (widget.data[index].myEmojis!.isNotEmpty) {
                emojiType = widget.data[index].myEmojis?[0]["emoji"];
                emojiTypeBool = true;
              } else {
                emojiType = "";
                emojiTypeBool = false;
              }
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color:widget.isDarkMode?const Color(0xff1e1e1e):Colors.white,
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
                              widget.data[index].imageUrl == null
                                  ? InkWell(
                              onTap: ()async{
                                        if (!await launchUrl(Uri.parse(
                                            widget.data[index].newsUrl))) {
                                          throw Exception(
                                              'Could not launch url');
                                        }
                                      },
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                            child: Image.asset(
                                                "assets/images/logo.png")),
                                      ),
                                  )
                                  : InkWell(
                                onTap: ()async{
                                  if (!await launchUrl(
                                  Uri.parse(widget.data[index].newsUrl))) {
                                  throw Exception('Could not launch url');
                                  }
                                },
                                    child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  widget.data[index].imageUrl!),
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
                              border: Border.all(color: const Color(0xffCDC8BC)),
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                                 SimpleText(
                                  text: "Ekonara",
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  textHeight: 1,
                                  fontColor: Colors.white,
                                ),
                              ],
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
                                HomePostLikeEvent(
                                    postData: widget.data[index],
                                    previousEmojiType: emojiType,
                                    emojisType: "",
                                    listOfData: widget.data,
                                    selectedTag: widget.selectedTag,
                                  listOfFutureData: widget.listOfFutureData
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
                                  width: 22,
                                  height: 22,
                                ),
                                widget.data[index].love != null
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 6),
                                  child: SimpleText(
                                    text: widget.data[index]
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
                                  HomePostLikeEvent(
                                      postData: widget.data[index],
                                      previousEmojiType: emojiType,
                                      emojisType: "love",
                                      listOfData: widget.data,
                                      selectedTag: widget.selectedTag,
                                      listOfFutureData: widget.listOfFutureData
                                  ));
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
                                  width: 22,
                                  height: 22,
                                ),
                                widget.data[index].love != null
                                    ? const SizedBox(
                                  width: 5,
                                )
                                    : const SizedBox(),
                                SimpleText(
                                  text: widget.data[index].love != null
                                      ? widget.data[index].love.toString()
                                      : "",
                                  fontSize: 12,
                                  fontColor: const Color(0xff060606),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          InkWell(
                            onTap: () {
                              bookmarkOrNot = !bookmarkOrNot;
                              BlocProvider.of<HomeBloc>(context).add(
                                  HomeBookmarkPostEvent(
                                      postData: widget.data[index],
                                      listOfData: widget.data,
                                      bookmark: bookmarkOrNot,
                                      selectedTag: widget.selectedTag,
                                      listOfFutureData: widget.listOfFutureData
                                  ));
                            },
                            child: bookmarkOrNot
                                ? widget.isDarkMode? SvgPicture.asset(
                                        "assets/svg/bookmark_dark.svg")
                                    :SvgPicture.asset(
                                "assets/svg/bookmarked.svg", width: 22,
                              height: 22,)
                                : SvgPicture.asset(
                                "assets/svg/bookmark.svg", width: 22,
                                height: 22,),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              shareImageTextAndURL(postModel:  widget.data[index]);
                            },
                            child: SvgPicture.asset("assets/svg/share.svg",height: 28,width: 22,),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xffE8ECF4),
                    ),
                    SimpleText(
                      text:translateHindi &&
                          widget.data[index].summaryHi != null ?
                      widget.data[index].summaryHi!.title
                      :widget.data[index].summary.title,
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.w500,
                      fontColor: const Color(0xff002D42),
                      textHeight: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: translateHindi &&
                                widget.data[index].summaryHi != null
                            ? widget.data[index].summaryHi?.keyPoints.length:
                        widget.data[index].summary.keyPoints.length,
                        itemBuilder: (context, keyIndex) {
                          var keyPoints =translateHindi && widget.data[index].summaryHi!= null ?
                          widget.data[index].summaryHi?.keyPoints[keyIndex]:
                          widget.data[index].summary.keyPoints[keyIndex];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:keyPoints?.subHeading== ""? "":"${keyPoints?.subHeading} ",
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.5.sp,
                                      color: widget.isDarkMode ?
                                      Colors.white :const Color(0xff2B2B2B),
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: keyPoints?.description.trim(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.5.sp,
                                      color: widget.isDarkMode ?
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(
                                Uri.parse(widget.data[index].newsUrl))) {
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
                                  text: widget.data[index].source,
                                  fontSize: 10,
                                  fontColor: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.isAdmin
                            ? InkWell(
                            onTap: () {
                              BlocProvider.of<HomeBloc>(context).add(
                                  AdminActionEvent(
                                      postData: widget.data[index],
                                      listOfData: widget.data,
                                      selectedTag: widget.selectedTag,
                                      listOfFutureData: widget.listOfFutureData
                                  ));
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ))
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              );
            }}),
    );
  }
}
