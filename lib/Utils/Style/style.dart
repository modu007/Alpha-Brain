import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: isDarkTheme ? Colors.black54 : Colors.white,
      indicatorColor: isDarkTheme ? Colors.black54 : const Color(0xffCBDCF8),
      disabledColor: Colors.grey,
      textTheme: Theme.of(context).textTheme.copyWith(
            titleLarge: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 16.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            displayLarge: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 10.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 14.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 12.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 15.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
      drawerTheme: DrawerThemeData(
        backgroundColor: isDarkTheme ? Colors.black:Colors.white,
      ),
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black54 : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black54),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
          background: isDarkTheme ? Colors.black54 : const Color(0xffF7F8FA)),
    );
  }
}
