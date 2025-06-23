import 'package:edu_sync/models/group_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupServices {
  static Future<bool> addGroup(GroupModel group) async {
    final supClient = Supabase.instance.client;
    try {
      await supClient.from('Groups').insert(group.toJson());
      return true;
    } catch (e) {
      print('❗ Ошибка при добавлении группы: $e');
      return false;
    }
  }

  static Future<List<GroupModel>> getGroupsByInstitutionId(
    int institutionId,
  ) async {
    final supClient = Supabase.instance.client;
    try {
      final response = await supClient
          .from('Groups')
          .select()
          .eq('institute_id', institutionId);

      return (response as List)
          .map((json) => GroupModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❗ Ошибка при получении списка групп: $e');
      return [];
    }
  }
}
