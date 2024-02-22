import 'package:flutter/material.dart';
import '../../Color/colors.dart';

class TextFormContainer extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  const TextFormContainer({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: ColorClass.backCardColor,
              width: 2
          ),
      ),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        decoration:  InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
