import 'package:get/get.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/models/sale/sale_items_model.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/services/sale_services.dart';
import 'package:selling_project/services/customer_services.dart';

class SaleController extends GetxController {

  final SaleServices service = SaleServices();
final CustomerServices customerService =
    CustomerServices();
  RxBool loading = false.obs;

   RxList<SaleModel> sales =
      <SaleModel>[].obs;

  RxList<SaleItemModel> saleItems =
      <SaleItemModel>[].obs;

      final customer =
    Rxn<CustomerModel>();

    RxBool loadingItems = false.obs;

   @override
  void onInit() {
    super.onInit();

    service.getSale().listen((data) {
      sales.value = data;
    });
  }

Future<void> loadCustomer(
  String customerId,
) async {

  customer.value =
  await customerService
      .getCustomerById(
        customerId,
      );
}


  void gotoSaleScreen() {
    Get.toNamed(AppRoute.sale);
  }

  Future<void> createSale() async {

    loading.value = true;

    try {

      // Create sale document
      SaleModel sale = SaleModel(
        invoiceNo: "INV002",
        customerId: "UNqPzjSqpMTWTcUs1jLN",
        userId: "USER002",
        subtotal: 20,
        totalAmount: 20,
        paymentStatus: "paid",
        saleDate: DateTime.now(),
      );

      String saleId =
          await service.addSale(sale);

      // Create sale item
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
  SaleItemModel(
    productId: "P002",
    productName: "Mouse",
    categoryId: "CAT002",
    categoryName: "Accessories",
    quantity: 3,
    unitPrice: 10,
    totalPrice: 30,
  ),
  SaleItemModel(
    productId: "P003",
    productName: "Keyboard",
    categoryId: "CAT002",
    categoryName: "Accessories",
    quantity: 1,
    unitPrice: 20,
    totalPrice: 20,
  ),
];

for (final items in item) {
  await service.addSaleItem(
    saleId,
    items,
  );
}
      Get.snackbar(
        "Success",
        "Sale saved",
      );

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      loading.value = false;

    }
  }

  void loadSaleItems(
    String saleId,
  ) {
    service
        .getSaleItems(saleId)
        .listen((data) {
      saleItems.value = data;
    });
  }
}