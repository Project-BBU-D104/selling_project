import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/services/customer_services.dart';

class CustomerController extends GetxController {
  final CustomerServices service = CustomerServices();

  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxList<CustomerModel> filteredCustomers = <CustomerModel>[].obs;
  RxBool loading = false.obs;

  var selectedCategory = 'Standard'.obs;
  var currentSingleFilter = 'All'.obs;
  var lastSearchKeyword = ''.obs;

  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCustomers();
  }

  void getCustomers() {
    loading.value = true;
    service.getCustomers().listen((data) {
      customers.value = data;
      _applySearchAndFilter();
      loading.value = false;
    });
  }
  
  Future<void> addCustomer() async {
    loading.value = true;
    try {
      CustomerModel customer = CustomerModel(
        customerName: customerNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        status: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: selectedCategory.value,
      );

      await service.addCustomer(customer);
      clearForm();
      Get.back();
      Get.snackbar(
        "Success",
        "Customer added successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green[800],
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red[800],
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateCustomer(String id) async {
    loading.value = true;
    try {
      CustomerModel customer = CustomerModel(
        id: id,
        customerName: customerNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        status: true,
        updatedAt: DateTime.now(),
        category: selectedCategory.value,
      );

      await service.updateCustomer(customer);
      clearForm();
      Get.back();
      Get.snackbar(
        "Success",
        "Customer updated successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green[800],
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red[800],
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await service.deleteCustomer(id);
      Get.snackbar(
        "Success",
        "Customer deleted successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange[800],
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red[800],
      );
    }
  }

  void setCustomer(CustomerModel customer) {
    customerNameController.text = customer.customerName;
    phoneController.text = customer.phone;
    emailController.text = customer.email;
    addressController.text = customer.address ?? '';
    selectedCategory.value = customer.category ?? 'Standard';
  }

  void clearForm() {
    customerNameController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    selectedCategory.value = 'Standard';
  }

  void selectSingleFilter(String category) {
    currentSingleFilter.value = category;
    if (category == 'All') {
      lastSearchKeyword.value = '';
    }
    _applySearchAndFilter();
  }

  void searchCustomer(String keyword) {
    lastSearchKeyword.value = keyword;
    _applySearchAndFilter();
  }

  void _applySearchAndFilter() {
    List<CustomerModel> tempResults = customers;
    if (lastSearchKeyword.value.isNotEmpty) {
      tempResults = tempResults.where((customer) {
        return customer.customerName.toLowerCase().contains(lastSearchKeyword.value.toLowerCase()) ||
            customer.phone.contains(lastSearchKeyword.value);
      }).toList();
    }
    if (currentSingleFilter.value != 'All') {
      tempResults = tempResults.where((customer) {
        return customer.category == currentSingleFilter.value;
      }).toList();
    }

    filteredCustomers.value = tempResults;
  }

  @override
  void onClose() {
    customerNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}