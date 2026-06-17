import 'package:selling_project/models/brand_model.dart';
import 'package:selling_project/services/api_services.dart';
class BrandServices {

  final ApiServices api = ApiServices();
  final String collection = "brands";

  // GET
  Stream<List<BrandModel>> getBrands() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return BrandModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addBrand(
      BrandModel brand
  ) async {
    return await api.post(
      collection,
      brand.toJson()
    );
  }
  // UPDATE
  Future<void> updateBrand(
      BrandModel brand
  ) async {
    await api.put(
      collection,
      brand.id!,
      brand.toJson()
    );
  }
  // DELETE
  Future<void> deleteBrand(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}