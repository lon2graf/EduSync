import 'package:edu_sync/models/lesson_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LessonServices {
  static final supabase = Supabase.instance.client;

  static Future<bool> addLesson(LessonModel lesson) async {
    try {
      final response =
          await supabase
              .from('Lessons')
              .insert(lesson.toJson())
              .select()
              .single();

      return true;
    } catch (e) {
      print('❌ Ошибка при добавлении занятия: $e');
      return false;
    }
  }

  static Future<List<LessonModel>> getLessonsByTeacherId(int teacherId) async {
    final _supClient = Supabase.instance.client;

    try {
      final response = await _supClient
          .from('Lessons')
          .select()
          .eq('teacher_id', teacherId);

      final lessons =
          (response as List<dynamic>)
              .map((json) => LessonModel.fromJson(json))
              .toList();

      return lessons;
    } catch (e) {
      print('Ошибка при получении занятий: $e');
      return [];
    }
  }

  static Future<LessonModel?> getLessonById(int lessonId) async {
    final _supClient = Supabase.instance.client;

    try {
      final response =
          await _supClient.from('Lessons').select().eq('id', lessonId).single();

      return LessonModel.fromJson(response);
    } catch (e) {
      print('Ошибка при получении занятий: $e');
      return null;
    }
  }
}
