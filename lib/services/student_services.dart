import 'package:edu_sync/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentServices {
  static final _client = Supabase.instance.client;

  static Future<List<StudentModel>> getStudentsByGroupId(int groupId) async {
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
    try {
      await _client.from('Students').insert(student.toJson());
      return true;
    } catch (e) {
      print('❗ Ошибка при добавлении студента: $e');
      return false;
    }
  }
}
