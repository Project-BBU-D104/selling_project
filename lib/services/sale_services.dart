import 'package:selling_project/models/sale/sale_items_model.dart';
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

  Future<void> addSaleItem(
    String saleId,
    SaleItemModel item,
  ) async {
    await api.postSubCollection(
      collection,
      saleId,
      "sale_items",
      item.toJson(),
    );
  }
   Stream<List<SaleItemModel>> getSaleItems(
    String saleId,
  ) {
    return api
        .getSubCollection(
          collection,
          saleId,
          "sale_items",
        )
        .map((data) {
      return data.map((item) {
        return SaleItemModel.fromJson(
          item,
          item["id"],
        );
      }).toList();
    });
}
}