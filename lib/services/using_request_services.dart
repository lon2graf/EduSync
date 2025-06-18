import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:edu_sync/models/using_request_model.dart';

class UsingRequestServices {
  //отправка заявки
  static Future<bool> submitRequest(UsingRequestModel request) async {
    final supClient = Supabase.instance.client;
    try {
      await supClient.from('Using_requests').insert(request.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //получение статуса заявки по email
  static Future<bool?> getRequestStatusByEmail(String email) async {
    final supClient = Supabase.instance.client;
    try {
      final response =
          await supClient
              .from('Using_requests')
              .select('isAccepted')
              .eq('email', email)
              .single();
      return response['isAccepted'] as bool?;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //получение модели заявки по email
  static Future<UsingRequestModel?> getRequestByEmail(String email) async {
    final supClient = Supabase.instance.client;
    try {
      final response =
          await supClient
              .from('Using_requests')
              .select()
              .eq('email', email)
              .maybeSingle();

      if (response != null) {
        print(response);
        return UsingRequestModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      print('Ошибка при получении заявки: $e');
      return null;
    }
  }
}
