import 'dart:convert';

import 'package:laundry_app/data/models/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSessions {
  static Future<UserModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    String? userString = pref.getString('user');
    if (userString == null) return null;

    final userMap = jsonDecode(userString);
    final data = UserModel.fromJson(userMap);
    return data;
  }

  static Future<bool> setUser(Map userMap) async {
    final pref = await SharedPreferences.getInstance();
    String userString = jsonEncode(userMap);
    bool success = await pref.setString('user', userString);
    return success;
  }

  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    return success;
  }

  static Future<String?> getBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('bearer_token');
    return token;
  }

  static Future<bool> setBearerToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.setString('bearer_token', token);
    return success;
  }

  static Future<bool> removeBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('bearer_token');
    return success;
  }
}
