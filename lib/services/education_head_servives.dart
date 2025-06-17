import 'package:supabase_flutter/supabase_flutter.dart';

class EducationHeadServives {
  //метод для проверки, существует ли аккаунт админа по емаилу
  static Future<bool> isAccountExistByEmail(String email) async {
    final supClient = Supabase.instance.client;

    try {
      final response =
          await supClient
              .from('Education_heads')
              .select('email')
              .eq('email', email)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print('Ошибка при проверке существования аккаунта: $e');
      return false;
    }
  }
}
