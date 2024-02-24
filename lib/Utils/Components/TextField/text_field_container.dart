import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    super.key,
    required this.emailController,
    this.validator,
    required this.hintText,
    this.suffixIcon,
    this.onTap,
    this.readOnly,
    this.onChanged
  });

  final TextEditingController emailController;
  final String? Function(String?)? validator;
  final String hintText;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final bool? readOnly;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 10,
              left: 15),
          decoration: BoxDecoration(
              color: const Color(0xffE8ECF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xffE8ECF4),
              )
          ),
          child: TextFormField(
            onChanged: onChanged,
            readOnly: readOnly ?? false,
            onTap: onTap,
            validator: validator,
            controller: emailController,
            maxLines: 1,
            decoration:  InputDecoration(
                suffixIcon: suffixIcon !=null ? SizedBox(
                  height: 10,
                  width: 10,
                  child: suffixIcon,
                ):null,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: GoogleFonts.besley(
                    color: const Color(0xff8391A1),
                    fontSize: 15,
                    fontWeight:FontWeight.w600
                )
            ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
