import 'package:edu_sync/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentServices {
  static Future<List<StudentModel>> getStudentsByGroupId(int groupId) async {
    final _client = Supabase.instance.client;
    try {
      final response = await _client
          .from('Students')
          .select()
          .eq('group_id', groupId);

      return (response as List)
          .map((json) => StudentModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❗ Ошибка при получении студентов: $e');
      return [];
    }
  }

  static Future<bool> addStudent(StudentModel student) async {
    final _client = Supabase.instance.client;
    try {
      await _client.from('Students').insert(student.toJson());
      return true;
    } catch (e) {
      print('❗ Ошибка при добавлении студента: $e');
      return false;
    }
  }

  static Future<bool> loginStudent(String email, String password) async {
    final supClient = Supabase.instance.client;

    try {
      final response =
          await supClient
              .from('Students')
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

  static Future<StudentModel?> getStudentByEmail(String email) async {
    final _client = Supabase.instance.client;
    try {
      final response =
          await _client.from('Students').select().eq('email', email).single();

      return StudentModel.fromJson(response);
    } catch (e) {
      print('❗ Ошибка при получении студентов: $e');
      return null;
    }
  }
}
