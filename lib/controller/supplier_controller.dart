import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/supplier_model.dart';
import 'package:selling_project/services/supplier_services.dart';

class SupplierController extends GetxController {
  final SupplierServices service = SupplierServices();
  RxList<SupplierModel> suppliers = <SupplierModel>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSuppliers();
  }

  void getSuppliers() {
    loading.value = true;
    service.getSuppliers().listen((data) {
      suppliers.value = data;
      loading.value = false;
    }, onError: (error) {
      loading.value = false;
      Get.snackbar('Error Fetching', error.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    });
  }

  Future<void> addSupplier(SupplierModel supplier) async {
    try {
      await service.addSupplier(supplier);
      Get.back(); 
      Get.snackbar('Success', 'Supplier saved to Firestore', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error Saving', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> updateSupplier(SupplierModel supplier) async {
    try {
      if (supplier.id == null) {
        Get.snackbar('Update Refused', 'Missing reference document ID', backgroundColor: Colors.orange);
        return;
      }
      await service.updateSupplier(supplier);
      Get.back(); 
      Get.snackbar('Success', 'Supplier details modified', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Update Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      await service.deleteSupplier(id);
      Get.snackbar('Deleted', 'Supplier removed from directory', backgroundColor: Colors.black87, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Delete Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}