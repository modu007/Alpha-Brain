import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Bloc/HomeBloc/home_bloc.dart';
import '../../../Bloc/HomeBloc/home_event.dart';
import '../../../Models/for_you_model.dart';
import '../Text/simple_text.dart';

class PostListView extends StatelessWidget{
  const PostListView({
    super.key,
    required this.data,
    required this.scrollController,
  });
  final List<ForYouModel> data;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        itemCount: data.length,
        itemBuilder: (context,index){
          if (index == data.length-1) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        else{
          bool emojiTypeBool=false;
           var emojiType="";
           bool bookmarkOrNot =
           data[index].bookmarkCount == null ||
          data[index].bookmarkCount==0 ? false:true;
            if(data[index].myEmojis.isNotEmpty){
              emojiType = data[index].myEmojis[0]["emoji"];
              emojiTypeBool=true;
            }
            else{
              emojiType="";
            }
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
                            child: Image.asset("assets/images/logo.jpeg"),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SimpleText(
                              text: "Ayaba Onile-Ire",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textHeight: 1,
                            ),
                            SimpleText(
                              text: "@ayabaoniile_",
                              fontSize: 12,
                              textHeight: 2,
                              fontColor: Color(0xff8698A9),
                            )
                          ],
                        ),
                        const Spacer(),
                         SimpleText(
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
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(data[index].imageUrl),
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
                              if (!await launchUrl(Uri.parse(data[index].newsUrl))) {
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
                        child: Container(
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
                          child: emojiTypeBool?
                          InkWell(
                            onTap: (){
                              BlocProvider.of<HomeBloc>(context).add(
                                  PostLikeEvent(
                                      postData: data[index],
                                      previousEmojiType: emojiType,
                                      emojisType: "",
                                      listOfData: data)
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/svg/heart_filled.svg",),
                                const SizedBox(width: 5,),
                                const SimpleText(
                                  text: "101.9K",
                                  fontSize: 12,
                                  fontColor: Color(0xff060606),)
                              ],
                            ),
                          ):
                          InkWell(
                            onTap: (){
                              BlocProvider.of<HomeBloc>(context).add(
                                  PostLikeEvent(
                                      postData: data[index],
                                      previousEmojiType: emojiType,
                                      emojisType: "love",
                                      listOfData: data)
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/svg/heart.svg",),
                                const SizedBox(width: 5,),
                                const SimpleText(
                                  text: "101.9K",
                                  fontSize: 12,
                                  fontColor: Color(0xff060606),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 100,
                        child: InkWell(
                          onTap: (){
                            bookmarkOrNot =!bookmarkOrNot;
                            BlocProvider.of<HomeBloc>(context).add(
                               BookmarkPostEvent(
                                   postData: data[index],
                                   listOfData: data,
                                   bookmark: bookmarkOrNot)
                            );
                          },
                          child: Container(
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
                            child: bookmarkOrNot ?
                            SvgPicture.asset("assets/svg/bookmarked.svg"):
                            SvgPicture.asset("assets/svg/bookmark.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SimpleText(
                    text: data[index].summary.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10,),
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
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${keyPoints.subHeading} ",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff77818A),
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: keyPoints.description,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color:Color(0xff77818A),
                                      fontWeight: FontWeight.normal),
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
