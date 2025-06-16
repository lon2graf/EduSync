import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyIsApplicationSent = 'isApplicationSent';
  static const _keySendersEmail = 'sendersEmail';

  //фиксирует, что админ отравлял заявку
  static Future<void> setApplicationSent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsApplicationSent, value);
  }

  static Future<bool> isApplicationSent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsApplicationSent) ?? false;
  }

  /// Сохраняет email отправителя заявки
  static Future<void> setSendersEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySendersEmail, email);
  }

  /// Получает email отправителя заявки
  static Future<String?> getSendersEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySendersEmail);
  }
}
