import 'package:selling_project/models/purchase/purchase_items_model.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';
import 'package:selling_project/services/api_services.dart';

class PurchaseServices {
  final ApiServices api = ApiServices();
  final String collection = "purchases";

  // GET ALL PURCHASES
  Stream<List<PurchaseModel>> getPurchases() {
    return api.get(collection).map((data) {
      return data.map((item) {
        return PurchaseModel.fromJson(
          item,
          item["id"] ?? "",
        );
      }).toList();
    });
  }

  Future<String> addPurchase(PurchaseModel purchase) async {
    return await api.post(
      collection,
      purchase.toJson(),
    );
  }

  Future<void> updatePurchase(PurchaseModel purchase) async {
    if (purchase.id == null || purchase.id!.isEmpty) {
      throw Exception("Purchase ID cannot be null or empty during update.");
    }

    await api.put(
      collection,
      purchase.id!,
      purchase.toJson(),
    );
  }

  // DELETE PURCHASE
  Future<void> deletePurchase(String id) async {
    if (id.isEmpty) return;
    await api.delete(
      collection,
      id,
    );
  }

  Future<void> addPurchaseItem(
    String purchaseId,
    PurchaseItemsModel item,
  ) async {
    if (purchaseId.isEmpty) return;

    await api.postSubCollection(
      collection,
      purchaseId,
      "purchase_items",
      item.toJson(),
    );
  }
  Stream<List<PurchaseItemsModel>> getPurchaseItems(String purchaseId) {
    if (purchaseId.isEmpty) {
      return Stream.value([]);
    }

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
          item["id"] ?? "",
        );
      }).toList();
    });
  }
}