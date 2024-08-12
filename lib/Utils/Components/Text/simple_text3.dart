import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Provider/dark_theme_controller.dart';

class SimpleText3 extends StatelessWidget {
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
  const SimpleText3(
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Text(
      text,
      style: GoogleFonts.roboto(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: textHeight,
        decoration: textDecoration,
      ),
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}