import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
  });
  final List<BookmarkPostModel> data;
  final List<BookmarkPostModel>? futureData;
  final ScrollController scrollController;
  final bool isLoading;
  final bool isTab1;
  final bool isDataEmpty;
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
            var dataResult = data[index].likedPost[0];
            return Container(
              margin: const EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xffF8F8FA)
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xffF7F8F9),
                        spreadRadius: 4,
                        blurRadius: 2)
                  ]),
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
                          text: dataResult.dateTime.split("2024")[0],
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
                            dataResult.imageUrl ==null ?
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(child: Image.asset("assets/images/logo.png")),
                            ) :Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(dataResult.imageUrl!),
                                  )
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
                            color: Colors.transparent,
                            border: Border.all(
                                color: const Color(0xffCDC8BC)
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:  InkWell(
                            onTap: ()async{
                              if (!await launchUrl(Uri.parse(dataResult.newsUrl))) {
                                throw Exception('Could not launch url');
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/hindustan_times.png"),
                                const SizedBox(width: 5,),
                                const SimpleText(
                                  text: "The Hindu",
                                  fontSize: 8,
                                  fontColor:Colors.white,
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
                            isTab1? const SizedBox():Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffF8F8FA)
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/svg/heart_filled.svg",),
                                  const SizedBox(width: 5,),
                                  SimpleText(
                                    text: dataResult.love!=null ? dataResult.love.toString():"",
                                    fontSize: 12,
                                    fontColor: const Color(0xff060606),)
                                ],
                              )
                            ),
                            const SizedBox(width: 10,),
                            isTab1? Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffF8F8FA)
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                    )
                                  ]
                              ),
                              child: SvgPicture.asset("assets/svg/bookmarked.svg")
                            ):const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                  SimpleText(
                    text: dataResult.summary.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textHeight: 1,
                  ),
                  const SizedBox(height: 10,),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataResult.summary.keyPoints.length,
                      itemBuilder: (context,keyIndex){
                        var keyPoints = dataResult.summary.keyPoints[keyIndex];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${keyPoints.subHeading} ",
                                  style:  GoogleFonts.besley(
                                    fontSize: 15,
                                    color: const Color(0xff2B2B2B),
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: keyPoints.description,
                                  style:  GoogleFonts.besley(
                                    fontSize: 14,
                                    color:const Color(0xff2B2B2B),
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: 10,),
                ],
              ),
            );
          }
        });
  }
}
