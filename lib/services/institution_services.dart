import 'package:edu_sync/models/institution_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InstitutionService {
  static Future<int?> createInstitutionAndGetId(
    InstitutionModel institution,
  ) async {
    final supClient = Supabase.instance.client;

    try {
      final response =
          await supClient
              .from('Institutions')
              .insert(institution.toJson())
              .select('id') // возвращаем только id
              .maybeSingle();

      if (response != null && response['id'] != null) {
        print('✅ Institution created with ID: ${response['id']}');
        return response['id'] as int;
      } else {
        print('⚠️ Institution creation returned null or missing ID');
        return null;
      }
    } catch (e, stack) {
      print('❗ Ошибка при создании учреждения: $e');
      print('StackTrace: $stack');
      return null;
    }
  }
}
