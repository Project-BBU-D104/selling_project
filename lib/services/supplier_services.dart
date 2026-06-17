import 'package:selling_project/models/supplier_model.dart';
import 'package:selling_project/services/api_services.dart';
class SupplierServices {

  final ApiServices api = ApiServices();
  final String collection = "suppliers";

  // GET
  Stream<List<SupplierModel>> getSuppliers() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return SupplierModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addSupplier(
      SupplierModel supplier
  ) async {
    return await api.post(
      collection,
      supplier.toJson()
    );
  }
  // UPDATE
  Future<void> updateSupplier(
      SupplierModel supplier
  ) async {
    await api.put(
      collection,
      supplier.id!,
      supplier.toJson()
    );
  }
  // DELETE
  Future<void> deleteSupplier(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}