import 'package:get/get.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/models/sale/sale_items_model.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/services/sale_services.dart';
import 'package:selling_project/services/customer_services.dart';

class SaleController extends GetxController {
  final SaleServices service = SaleServices();
  final CustomerServices customerService = CustomerServices();
  RxBool loading = false.obs;

  RxList<SaleModel> sales = <SaleModel>[].obs;

  RxList<SaleItemModel> saleItems = <SaleItemModel>[].obs;

  final customer = Rxn<CustomerModel>();

  RxBool loadingItems = false.obs;

  RxBool loadingCustomer = false.obs;
  Rxn<CustomerModel> selectedCustomer = Rxn<CustomerModel>();

  @override
  void onInit() {
    super.onInit();

    service.getSale().listen((data) {
      sales.value = data;
    });
  }

  Future<void> loadCustomer(String customerId) async {
    try {
      loadingCustomer.value = true;
      customer.value = null;

      print("🔍 កំពុងស្វែងរក Customer ID: $customerId");

      final result = await customerService.getCustomerById(customerId);

      if (result != null) {
        customer.value = result;
        print("រកឃើញ Customer ឈ្មោះ: ${result.customerName}");
      } else {
        customer.value = null;
        print(
            "រកមិនឃើញទិន្នន័យ Customer នៅក្នុង Database ទេ! (Result is Null)");
      }
    } catch (e) {
      print("មាន Error ពេលទាញទិន្នន័យ Customer: $e");
      customer.value = null;
    } finally {
      loadingCustomer.value = false;
    }
  }

  void gotoSaleScreen() {
    Get.toNamed(AppRoute.sale);
  }

  Future<void> createSale() async {
    if (selectedCustomer.value == null) {
      Get.snackbar("Warning", "សូមជ្រើសរើសអតិថិជនជាមុនសិន!");
      return;
    }

    loading.value = true;

    try {
      SaleModel sale = SaleModel(
        invoiceNo:
            "INV${DateTime.now().millisecondsSinceEpoch}",
        customerId:
            selectedCustomer.value!.id,
        userId: "USER002",
        subtotal: 1050,
        totalAmount: 1050,
        paymentStatus: "paid",
        saleDate: DateTime.now(),
      );

      String saleId = await service.addSale(sale);
      final item = [
        SaleItemModel(
          productId: "P001",
          productName: "iPhone",
          categoryId: "CAT001",
          categoryName: "Phone",
          quantity: 2,
          unitPrice: 500,
          totalPrice: 1000,
        ),
      ];

      for (final items in item) {
        await service.addSaleItem(saleId, items);
      }
      selectedCustomer.value = null;

      Get.back();
      Get.snackbar("Success", "Sale saved successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

  void loadSaleItems(
    String saleId,
  ) {
    service.getSaleItems(saleId).listen((data) {
      saleItems.value = data;
    });
  }
}
