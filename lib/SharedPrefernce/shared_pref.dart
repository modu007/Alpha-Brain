import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static Future getToken(String key) async {
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

  static Future getEmail(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setEmail(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("email", token);
  }

  static Future setUserName(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("username", username);
  }

  static Future setName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", name);
  }

  static Future setProfilePic(String profilePic) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("profilePic", profilePic);
  }

  static Future removeUserid(key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
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

class SharedFcmToken {
  static Future getFcmToken(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static Future setFcmToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("fcmToken", token);
  }

  static Future removeFcmToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
