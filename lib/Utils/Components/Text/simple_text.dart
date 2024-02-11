import 'package:flutter/material.dart';

class SimpleText extends StatelessWidget {
  final String text;
  final Color? fontColor;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? textHeight;
  final TextOverflow? overflow;
  final String? fontFamily;
  final TextDecoration? textDecoration;
  final int? maxLines;
  const SimpleText(
      {super.key,
      required this.text,
       this.fontColor,
      required this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.textHeight,
      this.overflow,
      this.fontFamily,
      this.maxLines,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: fontFamily,
          color: fontColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: textHeight,
          overflow: overflow,
          decoration: textDecoration),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
