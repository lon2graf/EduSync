import 'package:edu_sync/models/grade_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GradeServices {
  static Future<bool> addOrUpdateGrade(GradeModel grade) async {
    final _supabase = Supabase.instance.client;
    try {
      // Проверяем, есть ли уже такая оценка
      final existing =
          await _supabase
              .from('Grades')
              .select()
              .eq('lesson_id', grade.lessonId)
              .eq('student_id', grade.studentId)
              .maybeSingle();

      if (existing != null) {
        // Обновляем существующую
        final id = existing['id'];
        await _supabase
            .from('Grades')
            .update({'grade_value': grade.gradeValue})
            .eq('id', id);
      } else {
        // Вставляем новую
        await _supabase.from('Grades').insert(grade.toJson());
      }

      return true;
    } catch (e) {
      print('Ошибка при добавлении/обновлении оценки: $e');
      return false;
    }
  }
}
