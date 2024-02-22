import 'package:flutter/material.dart';
import '../Text/simple_text.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
    required this.size,
    required this.centerText,
    required this.onPressed,
  });

  final Size size;
  final String centerText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: const Color(0xff4EB3CA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xffE8ECF4),
            )
        ),
        child:  Center(
          child: SimpleText(
            text: centerText,
            fontSize: 15,
            fontColor: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
