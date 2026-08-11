import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/auth_controller.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/services/stock_adjustment_services.dart';
import 'package:selling_project/services/storage_service.dart';

class StockAdjustmentController extends GetxController {
  final StockAdjustmentServices _service = StockAdjustmentServices();
  final StorageService _storageService = StorageService();

  final quantityController = TextEditingController();
  final reasonController = TextEditingController();
  final remarksController = TextEditingController();

  var isLoading = false.obs;
  var adjustmentType = 'ADD'.obs;
  var selectedProduct = Rxn<ProductModel>();

  RxList<StockAdjustmentModel> stockAdjustments = <StockAdjustmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.isRegistered<ProductController>()) {
      Get.find<ProductController>().fetchProducts();
    } else {
      Get.put(ProductController());
    }

    stockAdjustments.bindStream(_service.getStockAdjustments());
  }

  void selectProduct(ProductModel product) {
    selectedProduct.value = product;
  }

  void clearSelectedProduct() {
    selectedProduct.value = null;
  }

  void increaseQuantity() {
    int val = int.tryParse(quantityController.text) ?? 0;
    quantityController.text = (val + 1).toString();
  }

  void decreaseQuantity() {
    int val = int.tryParse(quantityController.text) ?? 0;
    if (val > 1) {
      quantityController.text = (val - 1).toString();
    }
  }

  Iterable<ProductModel> filterProducts(
      String query, List<ProductModel> allProducts) {
    if (query.isEmpty) {
      return allProducts;
    }
    final lowerQuery = query.toLowerCase();
    return allProducts.where((ProductModel p) {
      final nameMatches =
          (p.productName ?? '').toLowerCase().contains(lowerQuery);
      final skuMatches = (p.id ?? '').toLowerCase().contains(lowerQuery);
      return nameMatches || skuMatches;
    });
  }

  Future<void> addAdjustment() async {
    if (selectedProduct.value == null) {
      Get.snackbar(
        'Error',
        'Please select a product',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (quantityController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter quantity',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    int qty = int.tryParse(quantityController.text.trim()) ?? 0;
    if (qty <= 0) {
      Get.snackbar(
        'Error',
        'Quantity must be greater than 0',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (adjustmentType.value == 'SUBTRACT' &&
        qty > selectedProduct.value!.quantity) {
      Get.snackbar(
        'Warning',
        'Quantity to subtract ($qty) exceeds current stock (${selectedProduct.value!.quantity})!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      String? currentUserId;
      String? currentUserName;

      // 1. ព្យាយាមទាញយកពី AuthController ជាមុនសិន
      if (Get.isRegistered<AuthController>()) {
        final authCtrl = Get.find<AuthController>();
        currentUserId = authCtrl.currentUser.value?.id;
        
        String? nameFromAuth = authCtrl.currentUser.value?.fullName;
        if (nameFromAuth != null && nameFromAuth.isNotEmpty && nameFromAuth != currentUserId) {
          currentUserName = nameFromAuth;
        } else {
          // បើគ្មាន fullName យក Email មកកាត់យកតែអក្សរមុខសញ្ញា @ (ឧទាហរណ៍ admin@gmail.com ទៅជា admin)
          String? email = authCtrl.currentUser.value?.email;
          if (email != null && email.contains('@')) {
            currentUserName = email.split('@').first;
          }
        }
      }

      // 2. បើរកមិនឃើញពី AuthController ទេ ទាញយកពី StorageService
      if (currentUserId == null || currentUserName == null) {
        try {
          final userData = _storageService.lastUserLoginRead;
          if (userData != null && userData is Map<String, dynamic>) {
            currentUserId ??= userData['id']?.toString();
            
            String? nameFromStorage = userData['full_name']?.toString();
            if (nameFromStorage != null && nameFromStorage.isNotEmpty && nameFromStorage != currentUserId) {
              currentUserName ??= nameFromStorage;
            } else {
              String? emailStorage = userData['email']?.toString();
              if (emailStorage != null && emailStorage.contains('@')) {
                currentUserName ??= emailStorage.split('@').first;
              }
            }
          }
        } catch (e) {
          print("Error reading user from storage: $e");
        }
      }

      // 3. Fallback ចុងក្រោយ បើគ្មានសោះ
      currentUserName ??= 'Staff';

      print("DEBUG SAVE -> User ID: $currentUserId, User Name: $currentUserName");

      StockAdjustmentModel newAdjustment = StockAdjustmentModel(
        productId: selectedProduct.value!.id ?? '',
        productName: selectedProduct.value!.productName,
        adjustmentType: adjustmentType.value,
        quantity: qty,
        reason: reasonController.text.trim(),
        userId: currentUserId,
        userName: currentUserName, // 👈 ឥឡូវនេះវាជារូបរាង Username ឬអក្សរមុន @ យ៉ាងស្រស់ស្អាត
        adjustmentDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _service.addStockAdjustment(
        newAdjustment,
        selectedProduct.value!.quantity,
      );

      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().fetchProducts();
      }

      clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Stock adjustment saved and updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAdjustment(String id) async {
    try {
      await _service.deleteStockAdjustment(id);
      Get.snackbar(
        'Success',
        'Data deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearForm() {
    selectedProduct.value = null;
    adjustmentType.value = 'ADD';
    quantityController.clear();
    reasonController.clear();
    remarksController.clear();
  }

  @override
  void onClose() {
    quantityController.dispose();
    reasonController.dispose();
    remarksController.dispose();
    super.onClose();
  }
}