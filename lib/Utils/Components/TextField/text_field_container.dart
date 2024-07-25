import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Provider/dark_theme_controller.dart';

import 'package:flutter/services.dart';

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regExp = RegExp(r'^[\w@.]*$'); // Removed \s from the regex
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}


class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    super.key,
    required this.emailController,
    this.validator,
    required this.hintText,
    this.suffixIcon,
    this.onTap,
    this.readOnly,
    this.onChanged,
    this.keyboardType,
    this.inputFormatter
  });

  final TextEditingController emailController;
  final String? Function(String?)? validator;
  final String hintText;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final bool? readOnly;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
              top: 6,
              bottom: 6,
              right: 10,
              left: 15),
          decoration: BoxDecoration(
              color: themeChange.darkTheme?
              const Color(0xff2F2F2F):const Color(0xffE8ECF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xffE8ECF4),
              )
          ),
          child: TextFormField(
            inputFormatters: inputFormatter,
            onChanged: onChanged,
            readOnly: readOnly ?? false,
            onTap: onTap,
            validator: validator,
            controller: emailController,
            maxLines: 1,
            keyboardType: keyboardType,
            style: GoogleFonts.besley(
                color: themeChange.darkTheme
                    ? Colors.white
                    : const Color(0xff8391A1),
                fontSize: 15,
                fontWeight: FontWeight.w600),
            decoration:InputDecoration(
              contentPadding:suffixIcon !=null? const EdgeInsets.only(top: 13):null,
                suffixIcon: suffixIcon !=null ? SizedBox(
                  height: 10,
                  width: 10,
                  child: suffixIcon,
                ):null,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: GoogleFonts.besley(
                    color: themeChange.darkTheme
                        ? Colors.white
                        : const Color(0xff8391A1),
                    fontSize: 14,
                    fontWeight:FontWeight.w600
                ),
            ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
