import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';

class HomeController extends GetxController{

  void gotoBrandScreen() {
    Get.toNamed(AppRoute.brand);
  }
  void gotoCategoryScreen() {
    Get.toNamed(AppRoute.category);
  }
  void gotoStockAdjustmentScreen() {
    Get.toNamed(AppRoute.stockAdjustment);
  }
  void gotoUserScreen() {
    Get.toNamed(AppRoute.user);
  }
  void gotoPurchaseScreen() {
    Get.toNamed(AppRoute.purchase);
  }
  void gotoPaymentScreen() {
    Get.toNamed(AppRoute.payment);
  }
  void gotoProductScreen() {
    Get.toNamed(AppRoute.product);
  }
  void gotoSaleListScreen() {
    Get.toNamed(AppRoute.saleList);
  }
  void gotoCustomerScreen() {
    Get.toNamed(AppRoute.customer);
  }
  void gotoSupplierScreen() {
    Get.toNamed(AppRoute.supplier);
  }
  void onLogout() {
    Get.toNamed(AppRoute.login);
  }
}