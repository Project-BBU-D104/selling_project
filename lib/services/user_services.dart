import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/services/api_services.dart';
class UserServices {

  final ApiServices api = ApiServices();
  final String collection = "users";

  // GET
  Stream<List<UserModel>> getUser() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return UserModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addUser(
      UserModel user
  ) async {
    return await api.post(
      collection,
      user.toJson()
    );
  }
  // DELETE
  Future<void> deleteUser(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}