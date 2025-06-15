import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyIsApplicationSent = 'isApplicationSent';

  //фиксирует, что админ отравлял заявку
  static Future<void> setApplicationSent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsApplicationSent, value);
  }

  static Future<bool> isApplicationSent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsApplicationSent) ?? false;
  }
}
