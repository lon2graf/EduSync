import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:edu_sync/models/lesson_comment_model.dart';

class LessonCommentService {
  /// Получить все комментарии по занятию
  static Future<List<LessonCommentModel>> getCommentsByLessonId(
    int lessonId,
  ) async {
    final _client = Supabase.instance.client;
    try {
      final response = await _client
          .from('Lessons_comments')
          .select()
          .eq('lesson_id', lessonId)
          .order('timestamp', ascending: true);

      return (response as List<dynamic>)
          .map((json) => LessonCommentModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Ошибка при загрузке комментариев: $e');
      return [];
    }
  }

  /// Добавить комментарий к занятию
  static Future<bool> addComment(LessonCommentModel comment) async {
    try {
      final _client = Supabase.instance.client;
      await _client.from('Lessons_comments').insert(comment.toJson());

      return true;
    } catch (e) {
      print('Ошибка при добавлении комментария: $e');
      return false;
    }
  }
}
