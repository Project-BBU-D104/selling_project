import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/models/sale/sale_items_model.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/screen/sale/sale_screen.dart';
import 'package:selling_project/services/customer_services.dart';
import 'package:selling_project/services/sale_services.dart';

class SaleController extends GetxController {
  final SaleServices service = SaleServices();
  final CustomerServices customerService = CustomerServices();

  late final ProductController productCtr;
  late final CategoryController categoryCtr;

  RxBool loading = false.obs;
  RxBool loadingItems = false.obs;

  RxList<SaleModel> sales = <SaleModel>[].obs;
  RxList<SaleItemModel> saleItems = <SaleItemModel>[].obs;
  final customer = Rxn<CustomerModel>();

  // POS State Management
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  RxList<SaleItemModel> cartItems = <SaleItemModel>[].obs;
  RxString selectedCategoryId = 'All'.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    // ចុះឈ្មោះ ឬទាញយក Controllers ដោយសុវត្ថិភាព
    productCtr = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    categoryCtr = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(CategoryController());

    super.onInit();

    service.getSale().listen((data) {
      sales.value = data;
    });

    ever(productCtr.product, (_) => filterProducts());
    filterProducts();
  }

  // Navigation Function (សម្រាប់ហៅចេញពី SaleListScreen)
  void gotoSaleScreen() {
    Get.to(() => SaleScreen());
  }

  // 2. Logic សម្រាប់ Filter និង Search Products
  void filterProducts() {
    List<ProductModel> temp = List.from(productCtr.product);

    // Filter By Category
    if (selectedCategoryId.value != 'All') {
      temp = temp.where((p) => p.categoryId == selectedCategoryId.value).toList();
    }

    // Filter By Search Query
    if (searchController.text.isNotEmpty) {
      String query = searchController.text.toLowerCase();
      temp = temp.where((p) => p.productName.toLowerCase().contains(query)).toList();
    }

    filteredProducts.assignAll(temp);
  }

  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    filterProducts();
  }

  // 3. Add to Cart Logic (កែសម្រួល Null-safety)
  void addToCart(ProductModel product) {
    int index = cartItems.indexWhere((item) => item.productId == product.id);

    if (index != -1) {
      var existing = cartItems[index];
      int newQty = existing.quantity + 1;
      cartItems[index] = SaleItemModel(
        id: existing.id,
        productId: existing.productId,
        productName: existing.productName,
        categoryId: existing.categoryId,
        categoryName: existing.categoryName,
        quantity: newQty,
        unitPrice: existing.unitPrice,
        totalPrice: newQty * existing.unitPrice,
      );
    } else {
      cartItems.add(
        SaleItemModel(
          productId: product.id ?? '',
          productName: product.name,
          categoryId: product.productName,
          categoryName: product.name ?? 'General',
          quantity: 1,
          unitPrice: product.price,
          totalPrice: product.price,
        ),
      );
    }
  }

  int get totalCartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalCartAmount => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  Future<void> loadCustomer(String customerId) async {
    try {
      customer.value = await customerService.getCustomerById(customerId);
    } catch (e) {
      customer.value = null;
    }
  }

  Future<void> createSale() async {
    if (cartItems.isEmpty) {
      Get.snackbar("Warning", "Cart is empty!");
      return;
    }

    loading.value = true;
    try {
      SaleModel sale = SaleModel(
        invoiceNo: "INV${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
        customerId: customer.value?.id,
        userId: "CURRENT_USER_ID",
        subtotal: totalCartAmount,
        totalAmount: totalCartAmount,
        paymentStatus: "paid",
        saleDate: DateTime.now(),
      );

      String saleId = await service.addSale(sale);

      for (final item in cartItems) {
        await service.addSaleItem(saleId, item);
      }

      cartItems.clear();
      Get.snackbar("Success", "Sale completed successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

  void loadSaleItems(String saleId) {
    loadingItems.value = true;
    service.getSaleItems(saleId).listen((data) {
      saleItems.value = data;
      loadingItems.value = false;
    }, onError: (err) {
      loadingItems.value = false;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}