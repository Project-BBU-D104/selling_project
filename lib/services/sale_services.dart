import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/services/api_services.dart';
class SaleServices {

  final ApiServices api = ApiServices();
  final String collection = "sale";

  // GET
  Stream<List<SaleModel>> getSale() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return SaleModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addSale(
      SaleModel sale
  ) async {
    return await api.post(
      collection,
      sale.toJson()
    );
  }
  // DELETE
  Future<void> deleteSale(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}