import 'package:flutter/material.dart';
import 'package:neuralcode/Utils/Components/Text/simple_text.dart';
import 'package:svg_flutter/svg.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: Row(
        children: [
          SvgPicture.asset("assets/svg/home.svg",height: 35,width: 35,),
          const SizedBox(width: 10,),
          const SimpleText(text: "Neural Code", fontSize: 25,fontWeight: FontWeight.w500,),
          const Spacer(),
          SvgPicture.asset("assets/svg/filter.svg",height: 35,width: 35,),
          const SizedBox(width: 10,),
         SizedBox(
           height: 45,
           width: 45,
           child:  ClipRRect(
             borderRadius: BorderRadius.circular(25),
             child: Image.asset("assets/images/profile-1.jpg"),
           ),
         )
        ],
      ),
    );
  }
}
