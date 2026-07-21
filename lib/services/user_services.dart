import 'dart:io';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/services/api_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final ApiServices _api = ApiServices();
  final String collection = 'users';

  // Supabase instance
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch users
  Stream<List<UserModel>> getUsers() {
    return _api.get(collection).map((snapshot) {
      return snapshot.map((json) => UserModel.fromJson(json)).toList();
    });
  }

  /// Upload image to Supabase Storage bucket 'user-images'
  Future<String?> uploadImage(File file) async {
    try {
      final extension = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final path = 'profiles/$fileName';

      // 2. Upload file ទៅកាន់ Supabase Storage
      await _supabase.storage.from('user-images').upload(
            path,
            file,
            fileOptions: FileOptions(
              cacheControl: '3600',
              contentType: 'image/$extension',
              upsert: false,
            ),
          );

      final String publicUrl =
          _supabase.storage.from('user-images').getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      throw Exception("Failed to upload image to Supabase: $e");
    }
  }

  /// Add new user
  Future<void> addUser(UserModel user) async {
    Map<String, dynamic> data = user.toJson();
    final generatedId = await _api.post(collection, data);
    await _api.put(collection, generatedId, {'id': generatedId});
  }

  /// Update existing user
  Future<void> updateUser(UserModel user) async {
    if (user.id == null || user.id!.isEmpty) {
      throw Exception("Cannot update user without a valid ID");
    }
    await _api.put(collection, user.id!, user.toJson());
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    await _api.delete(collection, id);
  }
}