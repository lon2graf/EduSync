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
}
