import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static Future getUserid(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
  }

  static Future getRefreshToken(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setRefreshToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("refresh", token);
  }

  static Future removeUserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}

class SharedLanguageData {
  static Future getLanguageData(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("lang", token);
  }

  static Future removeUserid(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("lang");
  }
}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class SharedName {
  static Future getUserName(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setUserName(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", token);
  }

  static Future removeUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
