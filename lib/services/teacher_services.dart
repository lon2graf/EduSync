import 'package:edu_sync/models/teacher_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherServices {
  static Future<bool> addTeacher(TeacherModel teacher) async {
    final supClient = Supabase.instance.client;
    try {
      final response = await supClient
          .from('Teachers')
          .insert(teacher.toJson());

      return true;
    } catch (e) {
      print('❗ Ошибка при добавлении учителя: $e');
      return false;
    }
  }

  static Future<List<TeacherModel>> getTeachersByInstitutionId(
    int institutionId,
  ) async {
    final supClient = Supabase.instance.client;

    try {
      final response = await supClient
          .from('Teachers')
          .select()
          .eq('institute_id', institutionId);

      return (response as List)
          .map((json) => TeacherModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❗ Ошибка при получении списка учителей: $e');
      return [];
    }
  }

  static Future<bool> loginTeacher(String email, String password) async {
    final supClient = Supabase.instance.client;

    try {
      final response =
          await supClient
              .from('Teachers')
              .select()
              .eq('email', email)
              .eq('password', password)
              .limit(1)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print('Ошибка при входе учителя: $e');
      return false;
    }
  }
}
