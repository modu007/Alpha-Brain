import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15,),
        SimpleText(
          text: headingText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontColor: const Color(0xff1E232C),
        ),
      ],
    );
  }
}
