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
  RxBool loadingItems = false.obs;

  RxList<SaleModel> sales = <SaleModel>[].obs;
  RxList<SaleItemModel> saleItems = <SaleItemModel>[].obs;
  final customer = Rxn<CustomerModel>();

  @override
  void onInit() {
    super.onInit();
    service.getSale().listen((data) {
      sales.value = data;
    });
  }

  Future<void> loadCustomer(String customerId) async {
    try {
      customer.value = await customerService.getCustomerById(customerId);
    } catch (e) {
      customer.value = null;
    }
  }

  void gotoSaleScreen() {
    Get.toNamed(AppRoute.sale);
  }

  Future<void> createSale() async {
    loading.value = true;
    try {
      SaleModel sale = SaleModel(
        invoiceNo: "INV002",
        customerId: "UNqPzjSqpMTWTcUs1jLN",
        userId: "USER002",
        subtotal: 20,
        totalAmount: 20,
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
      Get.snackbar("Success", "Sale saved");
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
}