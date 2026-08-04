import 'dart:async';
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

  late ProductController productCtr;
  late CategoryController categoryCtr;

  StreamSubscription? _salesSubscription;
  StreamSubscription? _saleItemsSubscription;
  StreamSubscription? _customersSubscription;

  final RxBool loading = false.obs;
  final RxBool loadingItems = false.obs;

  final RxList<SaleModel> sales = <SaleModel>[].obs;
  final RxList<SaleItemModel> saleItems = <SaleItemModel>[].obs;

  final customer = Rxn<CustomerModel>();
  final RxString selectedCustomerId = ''.obs;
  final RxString selectedCustomerName = 'General Customer'.obs;
  
  // បញ្ជី Customers សម្រាប់បង្ហាញពេលជ្រើសរើស
  final RxList<CustomerModel> customerList = <CustomerModel>[].obs;
  final RxBool loadingCustomers = false.obs;

  String get currentUserId => "usr_123";

  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxList<SaleItemModel> cartItems = <SaleItemModel>[].obs;
  final RxString selectedCategoryId = 'All'.obs;

  late TextEditingController searchController;

  bool get hasCustomerSelectDialog => true;

  @override
  void onInit() {
    searchController = TextEditingController();

    productCtr = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController(), permanent: true);

    categoryCtr = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(CategoryController(), permanent: true);

    super.onInit();

    // Handle Arguments
    if (Get.arguments != null) {
      if (Get.arguments is CustomerModel) {
        selectCustomer(Get.arguments as CustomerModel);
      } else if (Get.arguments is String) {
        loadCustomer(Get.arguments as String);
      }
    }

    _salesSubscription = service.getSale().listen(
      (data) {
        sales.value = data;
      },
      onError: (e) {
        debugPrint("Error fetching sales: $e");
      },
    );

    fetchCustomers();

    ever(productCtr.product, (_) => filterProducts());
    filterProducts();
  }

  void gotoSaleScreen() {
    Get.to(() => const SaleScreen());
  }

  void fetchCustomers() {
    loadingCustomers.value = true;
    _customersSubscription?.cancel();
    
    _customersSubscription = customerService.getCustomers().listen(
      (data) {
        customerList.assignAll(data);
        loadingCustomers.value = false;
      },
      onError: (e) {
        debugPrint("Error fetching customer list: $e");
        loadingCustomers.value = false;
      },
    );
  }

  void filterProducts() {
    List<ProductModel> temp = List.from(productCtr.product);

    if (selectedCategoryId.value != 'All') {
      temp =
          temp.where((p) => p.categoryId == selectedCategoryId.value).toList();
    }

    if (searchController.text.trim().isNotEmpty) {
      String query = searchController.text.trim().toLowerCase();
      temp = temp
          .where((p) => p.productName.toLowerCase().contains(query))
          .toList();
    }

    filteredProducts.assignAll(temp);
  }

  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    filterProducts();
  }

  void selectCustomer(CustomerModel selectedCust) {
    customer.value = selectedCust;
    selectedCustomerId.value = selectedCust.id ?? '';
    
    final String name = selectedCust.customerName;
    selectedCustomerName.value =
        name.trim().isNotEmpty ? name : 'General Customer';
  }

  // មុខងារកំណត់ឈ្មោះអតិថិជនផ្ទាល់ (សម្រាប់យកទៅប្រើជាមួយ BottomSheet ពេលកែប្រែ)
  void setCustomerByName(String name, String id) {
    selectedCustomerName.value = name.trim().isNotEmpty ? name : 'General Customer';
    selectedCustomerId.value = id;
    customer.value = null; 
  }

  // Bottom Sheet សម្រាប់ជ្រើសរើស Customer លើ SaleScreen
  void openCustomerSelectBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Customer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                )
              ],
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text("General Customer"),
              onTap: () {
                selectedCustomerId.value = '';
                selectedCustomerName.value = 'General Customer';
                customer.value = null;
                Get.back();
              },
            ),
            Expanded(
              child: Obx(() {
                if (loadingCustomers.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (customerList.isEmpty) {
                  return const Center(child: Text("No customers found"));
                }

                return ListView.builder(
                  itemCount: customerList.length,
                  itemBuilder: (context, index) {
                    final cust = customerList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF007AE5),
                        child: Text(
                          cust.customerName.isNotEmpty
                              ? cust.customerName[0].toUpperCase()
                              : "C",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(cust.customerName),
                      subtitle: Text(cust.phone ?? ''),
                      onTap: () {
                        selectCustomer(cust);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart(ProductModel product) {
    int index = cartItems.indexWhere((item) => item.productId == product.id);
    final catMatch = categoryCtr.category.firstWhereOrNull(
      (c) => c.id == product.categoryId,
    );
    String resolvedCategoryName = catMatch?.name ?? 'General';

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
        imageUrl: existing.imageUrl,
      );
    } else {
      cartItems.add(
        SaleItemModel(
          productId: product.id ?? '',
          productName: product.productName,
          categoryId: product.categoryId ?? '',
          categoryName: resolvedCategoryName,
          quantity: 1,
          unitPrice: product.price,
          totalPrice: product.price,
          imageUrl: product.imageUrl,
        ),
      );
    }
    cartItems.refresh();
  }

  void resetSale() {
    cartItems.clear();
    searchController.clear();
    selectedCategoryId.value = 'All';
    selectedCustomerId.value = '';
    selectedCustomerName.value = 'General Customer';
    customer.value = null;
    filterProducts();
  }

  int get totalCartCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalCartAmount =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  Future<void> loadCustomer(String customerId) async {
    try {
      final fetchedCustomer = await customerService.getCustomerById(customerId);
      if (fetchedCustomer != null) {
        selectCustomer(fetchedCustomer);
      }
    } catch (e) {
      customer.value = null;
      selectedCustomerId.value = '';
      selectedCustomerName.value = 'General Customer';
    }
  }

  Future<bool> createSale([SaleModel? customSaleData]) async {
    SaleModel saleToSave;

    if (customSaleData != null) {
      saleToSave = customSaleData;
      // 🔑 បញ្ចូលឈ្មោះអតិថិជនចុងក្រោយពី Controller ទៅក្នុង customSaleData ធានាថាអត់ភ្លេច
      saleToSave.customerName = selectedCustomerName.value;
      saleToSave.customerId = selectedCustomerId.value.isNotEmpty
          ? selectedCustomerId.value
          : null;
    } else {
      if (cartItems.isEmpty) {
        Get.snackbar(
          "Warning",
          "Cart is empty!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }

      saleToSave = SaleModel(
        invoiceNo: "INV-${DateTime.now().millisecondsSinceEpoch}",
        customerId: selectedCustomerId.value.isNotEmpty
            ? selectedCustomerId.value
            : null,
        customerName: selectedCustomerName.value,
        userId: currentUserId,
        subtotal: totalCartAmount,
        totalAmount: totalCartAmount,
        paymentStatus: "paid",
        saleDate: DateTime.now(),
        items: List.from(cartItems),
      );
    }

    loading.value = true;
    try {
      String saleId = await service.addSale(saleToSave);
      if (saleToSave.items != null && saleToSave.items!.isNotEmpty) {
        for (final item in saleToSave.items!) {
          await service.addSaleItem(saleId, item);
        }
      }
      resetSale();

      loading.value = false;
      return true;
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error",
        "Failed to save order: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  void loadSaleItems(String saleId) {
    loadingItems.value = true;
    _saleItemsSubscription?.cancel();
    _saleItemsSubscription = service.getSaleItems(saleId).listen(
      (data) {
        saleItems.value = data;
        loadingItems.value = false;
      },
      onError: (err) {
        loadingItems.value = false;
      },
    );
  }

  @override
  void onClose() {
    _salesSubscription?.cancel();
    _saleItemsSubscription?.cancel();
    _customersSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}