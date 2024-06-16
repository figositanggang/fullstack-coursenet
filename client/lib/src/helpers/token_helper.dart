// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class TokenHelper {
  static late SharedPreferences prefs;

  // ! Get user token
  static Future<String?> getToken() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getString("token");
  }

  // ! Save user token
  static Future<void> setToken(String token) async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
  }

  // ! Remove user token
  static Future<void> removeToken() async {
    prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");
  }
}
