import 'package:selling_project/models/purchase/purchase_items_model.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';
import 'package:selling_project/services/api_services.dart';
class PurchaseServices {

  final ApiServices api = ApiServices();
  final String collection = "purchase";

  // GET
  Stream<List<PurchaseModel>> getPurchases() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return PurchaseModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addPurchase(
      PurchaseModel purchase
  ) async {
    return await api.post(
      collection,
      purchase.toJson()
    );
  }
  // UPDATE
  Future<void> updatePurhcase(
      PurchaseModel purchase
  ) async {
    await api.put(
      collection,
      purchase.id!,
      purchase.toJson()
    );
  }
  // DELETE
  Future<void> deletePurchase(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }

  Future<void> addPurchaseItem(
    String purchaseId,
    PurchaseItemsModel item,
  ) async {
    await api.postSubCollection(
      collection,
      purchaseId,
      "purchase_items",
      item.toJson(),
    );
  }
   Stream<List<PurchaseItemsModel>> getPurchaseItems(
    String purchaseId,
  ) {
    return api
        .getSubCollection(
          collection,
          purchaseId,
          "purchase_items",
        )
        .map((data) {
      return data.map((item) {
        return PurchaseItemsModel.fromJson(
          item,
          item["id"],
        );
      }).toList();
    });
}
}