import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selling_project/controller/brand_controller.dart';
import 'package:selling_project/controller/supplier_controller.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/services/product_services.dart';

class ProductController extends GetxController {
  final ProductServices service = ProductServices();

  final brandCtrl = Get.isRegistered<BrandController>()
      ? Get.find<BrandController>()
      : Get.put(BrandController());

  final supplierCtrl = Get.isRegistered<SupplierController>()
      ? Get.find<SupplierController>()
      : Get.put(SupplierController());

  RxList<ProductModel> product = <ProductModel>[].obs;
  RxBool loading = false.obs;

  RxString searchQuery = ''.obs;
  RxString selectedFilter = 'All Products'.obs;
  final TextEditingController searchController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final productNameCtrl = TextEditingController();
  final costPriceCtrl = TextEditingController();
  final salePriceCtrl = TextEditingController();
  final quantityCtrl = TextEditingController(text: '0');
  final imageCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  Rxn<File> pickedImageFile = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  RxnString selectedBrandId = RxnString();
  RxnString selectedSupplierId = RxnString();
  RxBool status = true.obs;

  String? _editingId;
  DateTime? _editingCreatedAt;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  @override
  void onClose() {
    productNameCtrl.dispose();
    costPriceCtrl.dispose();
    salePriceCtrl.dispose();
    quantityCtrl.dispose();
    imageCtrl.dispose();
    descriptionCtrl.dispose();
    searchController.dispose();
    super.onClose();
  }

  List<ProductModel> get filteredProducts {
    return product.where((item) {
      final query = searchQuery.value.toLowerCase();
      final matchesSearch = query.isEmpty ||
          item.productName.toLowerCase().contains(query);

      if (!matchesSearch) return false;

      // ប្តូរលក្ខខណ្ឌពី Category GPU មកជា In Stock
      if (selectedFilter.value == 'In Stock') {
        return item.quantity > 0;
      } else if (selectedFilter.value == 'Stock Low') {
        return item.quantity > 0 && item.quantity <= 5;
      }
      return true;
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setFilter(String filterName) {
    selectedFilter.value = filterName;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        pickedImageFile.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  void initAddForm() {
    clearForm();
  }

  void initEditForm(ProductModel item) {
    _editingId = item.id;
    _editingCreatedAt = item.createdAt;

    productNameCtrl.text = item.productName;
    costPriceCtrl.text = item.costPrice.toString();
    salePriceCtrl.text = item.salePrice.toString();
    quantityCtrl.text = item.quantity.toString();
    imageCtrl.text = item.image ?? '';
    descriptionCtrl.text = item.description ?? '';
    selectedBrandId.value = item.brandId;
    selectedSupplierId.value = item.supplierId;
    status.value = item.status;
    pickedImageFile.value = null;
  }

  void clearForm() {
    _editingId = null;
    _editingCreatedAt = null;

    productNameCtrl.clear();
    costPriceCtrl.clear();
    salePriceCtrl.clear();
    quantityCtrl.text = '0';
    imageCtrl.clear();
    descriptionCtrl.clear();
    pickedImageFile.value = null;
    selectedBrandId.value = null;
    selectedSupplierId.value = null;
    status.value = true;
  }

  ProductModel get formData => ProductModel(
        id: _editingId,
        productName: productNameCtrl.text.trim(),
        costPrice: double.tryParse(costPriceCtrl.text.trim()) ?? 0.0,
        salePrice: double.tryParse(salePriceCtrl.text.trim()) ?? 0.0,
        quantity: int.tryParse(quantityCtrl.text.trim()) ?? 0,
        brandId: selectedBrandId.value,
        supplierId: selectedSupplierId.value,
        image: imageCtrl.text.trim().isEmpty ? null : imageCtrl.text.trim(),
        description: descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
        status: status.value,
        createdAt: _editingCreatedAt,
      );

  void getProducts() {
    loading.value = true;
    service.getProducts().listen((data) {
      product.value = data;
      loading.value = false;
    }, onError: (err) {
      loading.value = false;
    });
  }

  Future<void> submitSave() async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) return;
    await addProduct(formData);
  }

  Future<void> submitUpdate() async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) return;
    await updateProduct(formData);
  }

  Future<void> addProduct(ProductModel productData) async {
    loading.value = true;
    try {
      await service.addProduct(
        productData,
        imageFile: pickedImageFile.value,
      );
      clearForm();
      Get.back();
      Get.snackbar("Success", "Product added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel productData) async {
    loading.value = true;
    try {
      await service.updateProduct(
        productData,
        newImageFile: pickedImageFile.value,
      );
      clearForm();
      Get.back();
      Get.snackbar("Success", "Product updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await service.deleteProduct(id);
      Get.snackbar("Success", "Product deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}