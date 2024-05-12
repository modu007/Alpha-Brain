import 'package:flutter/material.dart';
import '../Text/simple_text.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
    required this.size,
    required this.centerText,
    required this.onPressed,
     this.color,
  });

  final Size size;
  final String centerText;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color:color ?? const Color(0xff4EB3CA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color == null
                  ? const Color(0xffE8ECF4)
                  : const Color(0xff4EB3CA),
            )
        ),
        child:  Center(
          child: SimpleText(
            text: centerText,
            fontSize: 15,
            fontColor:color==null ?Colors.white:Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
