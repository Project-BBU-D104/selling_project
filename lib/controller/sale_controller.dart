import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/models/sale/sale_items_model.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/screen/sale/sale_detail_screen.dart';
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
  RxString paymentMethod = 'Cash'.obs; // Cash, Card, Digital
  final searchController = TextEditingController();

  // Discount & Tax Settings
  double taxRate = 0.0825; // 8.25%
  double discountRate = 0.05; // 5%

  @override
  void onInit() {
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

  void filterProducts() {
    List<ProductModel> temp = List.from(productCtr.product);

    if (selectedCategoryId.value != 'All') {
      temp = temp.where((p) => p.categoryId == selectedCategoryId.value).toList();
    }

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

  // Cart Management
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
          productName: product.productName,
          categoryId: product.categoryId ?? '',
          categoryName: 'General',
          quantity: 1,
          unitPrice: product.price,
          totalPrice: product.price,
        ),
      );
    }
  }

  int getCartQuantityForProduct(String productId) {
    int index = cartItems.indexWhere((item) => item.productId == productId);
    return index != -1 ? cartItems[index].quantity : 0;
  }

  // Calculations
  int get totalCartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get taxAmount => subtotal * taxRate;
  double get discountAmount => subtotal * discountRate;
  double get finalTotalAmount => subtotal + taxAmount - discountAmount;

  // =========================================================
  // 🔹 ALIAS GETTERS & METHODS (សម្រាប់ផ្គូផ្គងជាមួយ UI)
  // =========================================================
  int get totalCartQuantity => totalCartCount;
  double get subtotalAmount => subtotal;
  List<ProductModel> get productList => filteredProducts;
  String get searchQuery => searchController.text;
  var isLoading = false.obs;

  int getCartItemQty(String productId) {
    return getCartQuantityForProduct(productId);
  }

  // Method សម្រាប់ Set តម្លៃ Search ពី UI
  void setSearchQuery(String value) {
    searchController.text = value;
    filterProducts();
  }

  // Method createSale សម្រាប់ដោះស្រាយ Error 'createSale' isn't defined
  Future<void> createSale() async {
    await confirmAndPay();
  }
  // =========================================================

  // Process Final Sale Checkout + Reduce Stock
  Future<void> confirmAndPay() async {
    if (cartItems.isEmpty) return;

    loading.value = true;
    try {
      // 1. បំប្លែង Cart Items (SaleItemModel) ទៅជា OrderItemModel សម្រាប់រក្សាទុកក្នុង SaleModel
      List<OrderItemModel> orderItems = cartItems.map((item) {
        return OrderItemModel(
          productId: item.productId,
          productName: item.productName,
          price: item.unitPrice,
          quantity: item.quantity,
        );
      }).toList();

      // 2. បង្កើត Object SaleModel ពេញលេញ
      final lastSale = SaleModel(
        invoiceNo: "INV${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
        customerId: customer.value?.id,
        customerName: customer.value?.customerName ?? "General Customer",
        userId: "CURRENT_USER_ID",
        subtotal: subtotal,
        discount: discountAmount,
        tax: taxAmount,
        totalAmount: finalTotalAmount,
        paymentStatus: "paid",
        paymentMethod: paymentMethod.value,
        saleDate: DateTime.now(),
        items: orderItems,
      );

      // 3. រក្សាទុកទិន្នន័យក្នុង Database
      String saleId = await service.addSale(lastSale);
      lastSale.id = saleId;

      // 4. រក្សាទុក Sale Items នីមួយៗ និងកាត់ស្តុក
      for (final item in cartItems) {
        await service.addSaleItem(saleId, item);

        if (item.productId.isNotEmpty) {
          await productCtr.decreaseProductStock(item.productId, item.quantity);
        }
      }

      // 5. បើកទៅកាន់ SaleDetailScreen ដោយប៉ាសតែ lastSale
      Get.off(() => SaleDetailScreen(sale: lastSale));
      cartItems.clear();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      loading.value = false;
    }
  }

  void resetSale() {
    cartItems.clear();
    paymentMethod.value = 'Cash';
  }

  Future<void> loadCustomer(String customerId) async {
    try {
      customer.value = await customerService.getCustomerById(customerId);
    } catch (e) {
      customer.value = null;
    }
  }

  void loadSaleItems(String saleId) {
    loadingItems.value = true;
    service.getSaleItems(saleId).listen((data) {
      saleItems.value = data;
      loadingItems.value = false;
    }, onError: (_) => loadingItems.value = false);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}