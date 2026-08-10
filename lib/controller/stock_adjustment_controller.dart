import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/auth_controller.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/services/stock_adjustment_services.dart';

class StockAdjustmentController extends GetxController {
  final StockAdjustmentServices _service = StockAdjustmentServices();
  
  final quantityController = TextEditingController();
  final reasonController = TextEditingController();

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

    if (adjustmentType.value == 'SUBTRACT' && qty > selectedProduct.value!.quantity) {
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

      if (Get.isRegistered<AuthController>()) {
        final authCtrl = Get.find<AuthController>();
        currentUserId = authCtrl.currentUser.value?.id;
        currentUserName = authCtrl.currentUser.value?.email; 
      }

      StockAdjustmentModel newAdjustment = StockAdjustmentModel(
        productId: selectedProduct.value!.id ?? '',
        productName: selectedProduct.value!.productName,
        adjustmentType: adjustmentType.value,
        quantity: qty,
        reason: reasonController.text.trim(),
        userId: currentUserId,
        userName: currentUserName,
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
  }

  @override
  void onClose() {
    quantityController.dispose();
    reasonController.dispose();
    super.onClose();
  }
}