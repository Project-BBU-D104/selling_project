import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/controller/supplier_controller.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/models/purchase/purchase_items_model.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';
import 'package:selling_project/models/supplier_model.dart';
import 'package:selling_project/services/purchase_services.dart';

class PurchaseController extends GetxController {
  final PurchaseServices service = PurchaseServices();

  SupplierController get supplierCtr {
    if (!Get.isRegistered<SupplierController>()) {
      return Get.put(SupplierController());
    }
    return Get.find<SupplierController>();
  }

  ProductController get productCtr {
    if (!Get.isRegistered<ProductController>()) {
      return Get.put(ProductController());
    }
    return Get.find<ProductController>();
  }

  RxList<PurchaseModel> purchases = <PurchaseModel>[].obs;
  RxList<PurchaseItemsModel> purchaseItems = <PurchaseItemsModel>[].obs;

  RxBool loading = false.obs;
  RxString selectedFilter = 'All Purchases'.obs;
  RxString searchQuery = ''.obs;

  double get totalMonthlyAmount {
    final now = DateTime.now();

    return purchases.where((p) {
      if (p.purchaseDate == null) return false;

      final date = p.purchaseDate!.toLocal();

      return date.month == now.month && date.year == now.year;
    }).fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
  }

  int get pendingOrdersCount {
    return purchases.where((p) {
      final status = p.status?.toLowerCase().trim() ?? '';
      return status == 'pending' || status == 'in transit';
    }).length;
  }

  Rxn<SupplierModel> selectedSupplier = Rxn<SupplierModel>();
  Rxn<ProductModel> selectedProduct = Rxn<ProductModel>();
  RxList<PurchaseItemsModel> tempItems = <PurchaseItemsModel>[].obs;

  List<DropdownMenuItem<SupplierModel>> get supplierDropdownItems {
    return supplierCtr.suppliers.map((sup) {
      return DropdownMenuItem<SupplierModel>(
        value: sup,
        child: Text(sup.name ?? "Unnamed Supplier"),
      );
    }).toList();
  }

  List<DropdownMenuItem<ProductModel>> get productDropdownItems {
    return productCtr.product.map((prod) {
      return DropdownMenuItem<ProductModel>(
        value: prod,
        child: Text(prod.name ?? "Unnamed Product"),
      );
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    getPurchases();
  }

  // Auto-Select Product ពេល Add រួចចេញពី Dialog
  void selectProductDirectly(ProductModel product) {
    selectedProduct.value = product;
  }

  // Fetch Purchases from Service
  void getPurchases() {
    loading.value = true;
    service.getPurchases().listen(
      (data) {
        purchases.value = data;
        loading.value = false;
      },
      onError: (error) {
        loading.value = false;
        debugPrint("Error fetching purchases: $error");
      },
    );
  }

  List<PurchaseModel> get filteredPurchases {
    var list = purchases.toList();

    if (selectedFilter.value == 'Pending') {
      list = list.where((p) {
        final status = p.status?.toLowerCase().trim() ?? '';
        return status == 'pending' || status == 'in transit';
      }).toList();
    } else if (selectedFilter.value == 'Completed') {
      list = list.where((p) {
        final status = p.status?.toLowerCase().trim() ?? '';
        return status == 'completed' || status == 'received';
      }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      list = list.where((p) {
        final supplier = p.supplierName?.toLowerCase() ?? '';
        // ✅ Fixed: Added Null-safe checks to avoid void/null method call errors
        final inv = p.invoiceNo?.toLowerCase() ?? '';
        return supplier.contains(query) || inv.contains(query);
      }).toList();
    }

    return list;
  }

  void changeFilter(String filter) => selectedFilter.value = filter;
  void changeSearchQuery(String query) => searchQuery.value = query;

  void clearForm() {
    selectedSupplier.value = null;
    selectedProduct.value = null;
    tempItems.clear();
  }

  void addTempItem(int qty, double price) {
    if (selectedProduct.value == null) return;

    tempItems.add(PurchaseItemsModel(
      productId: selectedProduct.value!.id ?? "",
      productName: selectedProduct.value!.name,
      quantity: qty,
      unitPrice: price,
      totalPrice: qty * price,
    ));

    selectedProduct.value = null;
  }

  void removeTempItem(int index) {
    if (index >= 0 && index < tempItems.length) {
      tempItems.removeAt(index);
    }
  }

  // Fetch Items សម្រាប់ដាក់ចូលក្នុង Edit Form
  Future<void> fetchPurchaseItemsForEdit(String purchaseId) async {
    loading.value = true;
    try {
      // ស្កែនទាញយក Stream ដំបូងមកប្រើ
      final items = await service.getPurchaseItems(purchaseId).first;
      tempItems.assignAll(items);
    } catch (e) {
      debugPrint("Error fetching purchase items for edit: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> submitPurchase({
    required String invoiceNo,
    required DateTime refDate,
    DateTime? expDeliveryDate,
  }) async {
    if (selectedSupplier.value == null || tempItems.isEmpty) return;

    double total = tempItems.fold(0.0, (sum, i) => sum + i.totalPrice);

    final newPurchase = PurchaseModel(
      supplierId: selectedSupplier.value!.id ?? "",
      supplierName: selectedSupplier.value!.name ?? "",
      invoiceNo: invoiceNo,
      totalAmount: total,
      purchaseDate: refDate,
      expectedDelivery: expDeliveryDate,
      status: 'Pending',
    );

    try {
      loading.value = true;
      String pId = await service.addPurchase(newPurchase);
      for (var item in tempItems) {
        await service.addPurchaseItem(pId, item);
      }
      clearForm();
    } catch (e) {
      debugPrint("Error submitting purchase: $e");
    } finally {
      loading.value = false;
    }
  }

  // Update Purchase Detail & Sync Items
  Future<void> updatePurchase(PurchaseModel purchase) async {
    try {
      loading.value = true;
      await service.updatePurchase(purchase);

      if (purchase.id != null) {
        for (var item in tempItems) {
          await service.addPurchaseItem(purchase.id!, item);
        }
      }
    } catch (e) {
      debugPrint("Error updating purchase: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> deletePurchase(String id) async {
    try {
      loading.value = true;
      await service.deletePurchase(id);
    } catch (e) {
      debugPrint("Error deleting purchase: $e");
    } finally {
      loading.value = false;
    }
  }

  void getPurchaseItems(String purchaseId) {
    loading.value = true;
    service.getPurchaseItems(purchaseId).listen(
      (data) {
        purchaseItems.value = data;
        loading.value = false;
      },
      onError: (error) {
        loading.value = false;
        debugPrint("Error getting purchase items: $error");
      },
    );
  }

  Future<void> addPurchaseItem(String purchaseId, PurchaseItemsModel item) async {
    await service.addPurchaseItem(purchaseId, item);
  }
}