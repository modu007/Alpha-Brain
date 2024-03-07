import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Text/simple_text.dart';

class BackButtonText extends StatelessWidget {
  final String titleText;
  final VoidCallback onPressed;

  const BackButtonText({
    super.key,
    required this.titleText,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
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
        ),
        const SizedBox(width: 15,),
         SimpleText(
          text: titleText,
          fontSize: 18,
          fontWeight: FontWeight.bold,),
      ],
    );
  }
}