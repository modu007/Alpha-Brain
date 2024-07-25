import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_bloc.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_event.dart';
import 'package:neuralcode/Models/bookmark_post_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Text/simple_text.dart';

class BookmarkPostCard extends StatelessWidget{
  const BookmarkPostCard({
    super.key,
    required this.data,
    required this.scrollController,
    required this.isLoading,
    required this.isTab1,
    required this.futureData,
    required this.isDataEmpty,
    required this.isDarkMode,
    required this.language,
  });
  final List<BookmarkPostModel> data;
  final List<BookmarkPostModel>? futureData;
  final ScrollController scrollController;
  final bool isLoading;
  final bool isTab1;
  final bool isDataEmpty;
  final bool isDarkMode;
  final bool language;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        itemCount: data.length,
        itemBuilder: (context,index){
          if (index == data.length-1 && isDataEmpty==false) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else{
            bool translateHindi=language;
            var dataResult = data[index].likedPost[0];
            return Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: isDarkMode?const Color(0xff1e1e1e):Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 210,
                        child: Column(
                          children: [
                            dataResult.imageUrl == null
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
                                        dataResult.imageUrl!),
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
                                text: "Alpha Brain",
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
                        isTab1?
                        SvgPicture.asset("assets/svg/heart_filled.svg",):
                        isDarkMode?
                        SvgPicture.asset("assets/svg/bookmark_dark.svg",):
                        SvgPicture.asset("assets/svg/bookmarked.svg",),
                        const SizedBox(width: 5,),
                        SimpleText(
                          text: dataResult.love!=null ? dataResult.love.toString():"",
                          fontSize: 12,
                          fontColor: const Color(0xff060606),),
                        const Spacer(),
                        // dataResult.summaryHi != null ?
                        // InkWell(
                        //   onTap: (){
                        //     translateHindi=!translateHindi;
                        //     BlocProvider.of<ProfileBloc>(context).add(
                        //         LanguageChangeBloc(
                        //             language: translateHindi,
                        //           listOfData: data,
                        //          allPrevPostData: futureData==null ?[]:futureData!,
                        //         )
                        //     );
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(6),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         border: Border.all(
                        //             color: const Color(0xffD8D8D8)
                        //         )
                        //     ),
                        //     child:isDarkMode ?
                        //     SvgPicture.asset("assets/svg/translate_dark.svg"):
                        //     SvgPicture.asset("assets/svg/translate.svg"),
                        //   ),
                        // ):const SizedBox()
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SimpleText(
                    text: translateHindi && dataResult.summaryHi != null
                        ? dataResult.summaryHi!.title
                        : dataResult.summary.title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontColor: const Color(0xff002D42),
                    textHeight: 1,
                  ),
                  const SizedBox(height: 10,),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: translateHindi &&
                          dataResult.summaryHi != null
                          ? dataResult.summaryHi?.keyPoints.length:
                      dataResult.summary.keyPoints.length,
                      itemBuilder: (context, keyIndex) {
                        var keyPoints =translateHindi && dataResult.summaryHi!= null ?
                        dataResult.summaryHi?.keyPoints[keyIndex]:
                        dataResult.summary.keyPoints[keyIndex];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5),
                          child: RichText(
                            text: TextSpan(
                              children: [
                            TextSpan(
                              text:keyPoints?.subHeading== ""? "":"${keyPoints?.subHeading} ",
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp,
                                color: isDarkMode ?
                                Colors.white :const Color(0xff2B2B2B),
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                              ),
                            ),
                            TextSpan(
                              text: keyPoints?.description.trim(),
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp,
                                color: isDarkMode ?
                                Colors.white :const Color(0xff2B2B2B),
                                height: 1.2,
                              ),
                            )],
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: 10,),
                  const Divider(
                    color: Color(0xffE8ECF4),
                  ),
                  InkWell(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse(dataResult.newsUrl))) {
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
                            text:dataResult.source,
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
          }
        });
  }
}
