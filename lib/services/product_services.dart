import 'package:selling_project/models/product_model.dart';
import 'package:selling_project/services/api_services.dart';
class ProductServices {

  final ApiServices api = ApiServices();
  final String collection = "product";

  // GET
  Stream<List<ProductModel>> getProducts() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return ProductModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addProduct(
      ProductModel product
  ) async {
    return await api.post(
      collection,
      product.toJson()
    );
  }
  // UPDATE
  Future<void> updateProduct(
      ProductModel product
  ) async {
    await api.put(
      collection,
      product.id!,
      product.toJson()
    );
  }
  // DELETE
  Future<void> deleteProduct(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}