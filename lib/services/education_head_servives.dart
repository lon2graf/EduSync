import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:edu_sync/models/education_head_model.dart';

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

  static Future<bool> registerEducationHead(EducationHeadModel model) async {
    final supClient = Supabase.instance.client;

    try {
      final response = await supClient
          .from('Education_heads')
          .insert(model.toJson());

      return true;
    } catch (e) {
      print('Ошибка при регистрации руководителя: $e');
      return false;
    }
  }

  static Future<bool> loginEducationHead(String email, String password) async {
    final supClient = Supabase.instance.client;

    try {
      final response =
          await supClient
              .from('Education_heads')
              .select()
              .eq('email', email)
              .eq('password', password)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print('Ошибка при входе руководителя: $e');
      return false;
    }
  }
}
