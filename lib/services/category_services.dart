import 'package:selling_project/models/category_model.dart';
import 'package:selling_project/services/api_services.dart';
class CategoryServices {

  final ApiServices api = ApiServices();
  final String collection = "category";

  // GET
  Stream<List<CategoryModel>> getCategories() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return CategoryModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addCategory(
      CategoryModel category
  ) async {
    return await api.post(
      collection,
      category.toJson()
    );
  }
  // UPDATE
  Future<void> updateCategory(
      CategoryModel category
  ) async {
    await api.put(
      collection,
      category.id!,
      category.toJson()
    );
  }
  // DELETE
  Future<void> deleteCategory(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}