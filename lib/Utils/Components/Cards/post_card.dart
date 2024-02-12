import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';
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
                          child: Image.asset("assets/images/logo.jpeg"),
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
                  Row(
                    children: [
                      const SimpleText(
                        text: "source: ",
                        fontSize: 13,fontColor: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      InkWell(
                        onTap: ()async{
                          if (!await launchUrl(Uri.parse(data[index].newsUrl))) {
                            throw Exception('Could not launch url');
                          }
                        },
                        child: SimpleText(
                          text: data[index].source,
                          fontSize: 13,fontColor: Colors.grey,
                          fontWeight: FontWeight.w500,
                          textDecoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        });
  }
}
