import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/services/customer_services.dart';

class CustomerController extends GetxController {
  final CustomerServices service = CustomerServices();

  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxList<CustomerModel> filteredCustomers = <CustomerModel>[].obs;
  RxBool loading = false.obs;

  var lastSearchKeyword = ''.obs;
  var statusFilter = 'All'.obs;

  final customerNameController = TextEditingController();
  final customerTypeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final searchTxtController = TextEditingController();

  TextEditingController get searchController => searchTxtController;

  RxBool customerStatus = true.obs;

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
    }, onError: (e) {
      loading.value = false;
      Get.snackbar(
        "Error Loading Data",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red[800],
      );
    });
  }

  Future<void> addCustomer() async {
    loading.value = true;
    try {
      final now = DateTime.now();
      CustomerModel customer = CustomerModel(
        customerName: customerNameController.text.trim(),
        customerType: customerTypeController.text.trim().isEmpty ? null : customerTypeController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
        status: customerStatus.value,
        createdAt: now,
        updatedAt: now,
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
        customerType: customerTypeController.text.trim().isEmpty ? null : customerTypeController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
        status: customerStatus.value,
        updatedAt: DateTime.now(),
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
    customerTypeController.text = customer.customerType ?? '';
    phoneController.text = customer.phone ?? '';
    emailController.text = customer.email ?? '';
    addressController.text = customer.address ?? '';
    customerStatus.value = customer.status;
  }

  void clearForm() {
    customerNameController.clear();
    customerTypeController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    customerStatus.value = true;
  }

  void searchCustomer(String keyword) {
    lastSearchKeyword.value = keyword;
    _applySearchAndFilter();
  }

  void filterByStatus(String status) {
    statusFilter.value = status;
    _applySearchAndFilter();
  }

  void _applySearchAndFilter() {
    List<CustomerModel> tempResults = List.from(customers);

    if (lastSearchKeyword.value.isNotEmpty) {
      String query = lastSearchKeyword.value.toLowerCase();
      tempResults = tempResults.where((customer) {
        final matchesName = customer.customerName.toLowerCase().contains(query);
        final matchesType = customer.customerType?.toLowerCase().contains(query) ?? false;
        final matchesPhone = customer.phone?.contains(query) ?? false;
        final matchesEmail = customer.email?.toLowerCase().contains(query) ?? false;
        return matchesName || matchesType || matchesPhone || matchesEmail;
      }).toList();
    }
    if (statusFilter.value == 'Active') {
      tempResults = tempResults.where((c) => c.status == true).toList();
    } else if (statusFilter.value == 'Inactive') {
      tempResults = tempResults.where((c) => c.status == false).toList();
    }

    filteredCustomers.value = tempResults;
  }

  @override
  void onClose() {
    customerNameController.dispose();
    customerTypeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    searchTxtController.dispose();
    super.onClose();
  }
}