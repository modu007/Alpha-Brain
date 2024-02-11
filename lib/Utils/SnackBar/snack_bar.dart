import 'package:flutter/material.dart';

class OpenSnackBar{
  static openSnackBar(String text){
    var snackBar = SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(text),
    );
    return snackBar;
  }
}