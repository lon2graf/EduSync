import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:edu_sync/models/using_request_model.dart';

class UsingRequestServices {
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
}
