import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoStorage {
  static const String _storageKey = 'user_info_flow_data';

  static Future<void> saveAnswers(Map<String, dynamic> answers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(answers));
  }

  static Future<Map<String, dynamic>> getAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data == null || data.isEmpty) return {};
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static Future<void> clearAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
