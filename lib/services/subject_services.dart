import 'package:edu_sync/models/subject_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectServices {
  static final _client = Supabase.instance.client;

  static Future<List<SubjectModel>> getSubjectsByInstitutionId(
    int institutionId,
  ) async {
    try {
      final response = await _client
          .from('Subjects')
          .select()
          .eq('institute_id', institutionId);

      return (response as List)
          .map((item) => SubjectModel.fromJson(item))
          .toList();
    } catch (e) {
      print('❗ Ошибка получения предметов: $e');
      return [];
    }
  }

  static Future<bool> addSubject(SubjectModel subject) async {
    try {
      await _client.from('Subjects').insert(subject.toJson());
      return true;
    } catch (e) {
      print('❗ Ошибка добавления предмета: $e');
      return false;
    }
  }
}
