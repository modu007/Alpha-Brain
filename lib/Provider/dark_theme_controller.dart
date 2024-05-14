import 'package:flutter/cupertino.dart';
import '../SharedPrefernce/shared_pref.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    DarkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}