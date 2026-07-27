import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/supplier_model.dart';
import 'package:selling_project/services/supplier_services.dart';

class SupplierController extends GetxController {
  final SupplierServices service = SupplierServices();
  
  RxList<SupplierModel> suppliers = <SupplierModel>[].obs;
  RxBool loading = false.obs;

  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final contactController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  
  RxBool isCheckedStatus = true.obs;

  @override
  void onInit() {
    super.onInit();
    getSuppliers();
  }

  void clearForm() {
    nameController.clear();
    companyController.clear();
    contactController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    isCheckedStatus.value = true;
  }

  void populateForm(SupplierModel supplier) {
    nameController.text = supplier.name;
    companyController.text = supplier.companyName ?? '';
    contactController.text = supplier.contactPerson ?? '';
    phoneController.text = supplier.phone;
    emailController.text = supplier.email;
    addressController.text = supplier.address ?? '';
    isCheckedStatus.value = supplier.status;
  }

  void getSuppliers() {
    loading.value = true;
    service.getSuppliers().listen((data) {
      suppliers.value = data;
      loading.value = false;
    }, onError: (error) {
      loading.value = false;
      Get.snackbar('Error Fetching', error.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    });
  }

  Future<void> addSupplier() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      Get.snackbar('Missing Data', 'Name and Phone inputs cannot be empty.',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      final newSupplier = SupplierModel(
        name: nameController.text.trim(),
        companyName: companyController.text.trim(),
        contactPerson: contactController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        status: true,
        createdAt: DateTime.now(),
      );

      await service.addSupplier(newSupplier);
      clearForm();
      Get.back();
      Get.snackbar('Success', 'Supplier saved successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error Saving', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> updateSupplier(String supplierId, DateTime? createdAt) async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      Get.snackbar('Missing Data', 'Name and Phone inputs cannot be empty.',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      final updatedSupplier = SupplierModel(
        id: supplierId,
        name: nameController.text.trim(),
        companyName: companyController.text.trim(),
        contactPerson: contactController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        status: isCheckedStatus.value,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

      await service.updateSupplier(updatedSupplier);
      clearForm();
      Get.back();
      Get.snackbar('Success', 'Supplier details updated',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Update Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      await service.deleteSupplier(id);
      Get.snackbar('Deleted', 'Supplier removed',
          backgroundColor: Colors.black87, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Delete Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    companyController.dispose();
    contactController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}