import 'package:selling_project/services/api_services.dart';
import 'package:selling_project/models/user_model.dart';

class UserService {
  final ApiServices _api = ApiServices();
  final String collection = 'users';

  Stream<List<UserModel>> getUsers() {
    return _api.get(collection).map((snapshot) {
      return snapshot.map((json) => UserModel.fromJson(json)).toList();
    });
  }

  Future<void> addUser(UserModel user) async {
    Map<String, dynamic> data = user.toJson();
    final generatedId = await _api.post(collection, data);
    await _api.put(collection, generatedId, {'id': generatedId});
  }

  Future<void> updateUser(UserModel user) async {
    if (user.id == null || user.id!.isEmpty) {
      throw Exception("Cannot update user without a valid ID");
    }
    await _api.put(collection, user.id!, user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _api.delete(collection, id);
  }
}