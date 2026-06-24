// import 'package:get/get.dart';

// class PurchaseController extends GetxController{

// }

import 'package:get/get.dart';
import 'package:selling_project/models/purchase/purchase_items_model.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';
import 'package:selling_project/services/purchase_services.dart';

class PurchaseController extends GetxController {
  final PurchaseServices service = PurchaseServices();

  RxList<PurchaseModel> purchases = <PurchaseModel>[].obs;
  RxList<PurchaseItemsModel> purchaseItems = <PurchaseItemsModel>[].obs;

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPurchases();
  }

  // =========================
  // Purchase
  // =========================

  void getPurchases() {
    loading.value = true;

    service.getPurchases().listen((data) {
      purchases.value = data;
      loading.value = false;
    });
  }

  Future<String> addPurchase(
    PurchaseModel purchase,
  ) async {
    return await service.addPurchase(purchase);
  }

  Future<void> addTestPurchase() async {
    final purchase = PurchaseModel(
      name: "Test Purchase",
      supplierId: "SUP001",
      invoiceNo: "INV001",
      totalAmount: 100,
      purchaseDate: DateTime.now(),
    );

    String purchaseId = await service.addPurchase(
      purchase,
    );

    final item = PurchaseItemsModel(
      purchaseId: purchaseId,
      productId: "PRO001",
      quantity: 5,
      unitPrice: 20,
      totalPrice: 100,
    );

    await service.addPurchaseItem(
      purchaseId,
      item,
    );
  }

  Future<void> updatePurchase(
    PurchaseModel purchase,
  ) async {
    await service.updatePurhcase(purchase);
  }

  Future<void> deletePurchase(
    String id,
  ) async {
    await service.deletePurchase(id);
  }

  // =========================
  // Purchase Items
  // =========================

  void getPurchaseItems(
    String purchaseId,
  ) {
    loading.value = true;

    service.getPurchaseItems(purchaseId).listen((data) {
      purchaseItems.value = data;
      loading.value = false;
    });
  }

  Future<void> addPurchaseItem(
    String purchaseId,
    PurchaseItemsModel item,
  ) async {
    await service.addPurchaseItem(
      purchaseId,
      item,
    );
  }
}
