import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../Text/simple_text.dart';

class BackButtonContainer extends StatelessWidget {
  final VoidCallback onPressed;
  final String headingText;
  const BackButtonContainer({
    super.key,
    required this.onPressed,
    required this.headingText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xffE8ECF4),
                )
            ),
            child:SvgPicture.asset("assets/svg/back_arrow.svg"),
          ),
          const SizedBox(height: 15,),
          SimpleText(
            text: headingText,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontColor: const Color(0xff1E232C),
          ),
        ],
      ),
    );
  }
}
