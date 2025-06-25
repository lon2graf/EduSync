import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:edu_sync/models/lesson_attendance_model.dart';

class AttendanceService {
  static Future<bool> addOrUpdateAttendance(LessonAttendance attendance) async {
    final _client = Supabase.instance.client;
    try {
      // Проверяем, существует ли запись
      final existing =
          await _client
              .from('Lessons_attendances')
              .select('id')
              .eq('lesson_id', attendance.lessonId)
              .eq('student_id', attendance.studentId)
              .maybeSingle();

      if (existing != null) {
        // Обновляем
        final id = existing['id'] as int;
        await _client
            .from('Lesson_attendances')
            .update({'status': attendance.status})
            .eq('id', id);
      } else {
        // Вставляем
        await _client.from('Lessons_attendances').insert(attendance.toJson());
      }

      return true;
    } catch (e) {
      print('Ошибка при добавлении/обновлении посещаемости: $e');
      return false;
    }
  }

  static Future<List<LessonAttendance>> getAttendanceByStudentId(
    int studentId,
  ) async {
    final _supabase = Supabase.instance.client;
    try {
      final response = await _supabase
          .from('Lessons_attendances')
          .select()
          .eq('student_id', studentId);

      return (response as List)
          .map((json) => LessonAttendance.fromJson(json))
          .toList();
    } catch (e) {
      print('Ошибка при получении оценок студента: $e');
      return [];
    }
  }
}
