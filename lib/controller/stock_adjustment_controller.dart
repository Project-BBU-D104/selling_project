import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/services/stock_adjustment_services.dart';

class StockAdjustmentController extends GetxController {
  final StockAdjustmentServices _services = StockAdjustmentServices();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final reasonController = TextEditingController();

  var adjustmentType = 'Decrease'.obs;
  var selectedProduct = <String, dynamic>{}.obs;

  var isLoading = false.obs;

  Stream<List<StockAdjustmentModel>> get stockAdjustmentsStream => _services.getStockAdjustments();

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    reasonController.dispose();
    super.onClose();
  }

  // clear form
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    quantityController.clear();
    reasonController.clear();
    adjustmentType.value = 'Decrease';
    selectedProduct.clear();
  }

  // add stock
  Future<void> addStockAdjustment() async {
    try {
      if (nameController.text.isEmpty || quantityController.text.isEmpty) {
        Get.snackbar("Error", "Please fill in all required fields", snackPosition: SnackPosition.BOTTOM);
        return;
      }

      isLoading.value = true;
      StockAdjustmentModel newAdjustment = StockAdjustmentModel(
        name: nameController.text,
        description: descriptionController.text,
        product: selectedProduct,
        adjustmentType: adjustmentType.value,
        quantity: int.parse(quantityController.text),
        reason: reasonController.text,
        adjustmentDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _services.addBrand(newAdjustment); 
      
      clearForm();
      Get.back();
      Get.snackbar("Success", "Stock adjustment recorded successfully", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to add: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  //delete stock
  Future<void> deleteStockAdjustment(String id) async {
    try {
      await _services.deleteStockAdjustment(id);
      Get.snackbar("Success", "Deleted successfully", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}