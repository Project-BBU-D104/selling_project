import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/services/user_services.dart';

class HomeController extends GetxController {
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    try {
      var fetchedUser = await UserService.getCurrentUser();
      user.value = fetchedUser;
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  void gotoBrandScreen() {
    Get.toNamed(AppRoute.brand);
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
    Get.toNamed(AppRoute.sale);
  }

  void gotoCustomerScreen() {
    Get.toNamed(AppRoute.customer);
  }

  void gotoSupplierScreen() {
    Get.toNamed(AppRoute.supplier);
  }

  void onLogout() {
    Get.offAllNamed(AppRoute.login);
  }

  void gotoSettingScreen() {
    Get.toNamed(AppRoute.setting);
  }

  void gotoDashboardScreen() {
    Get.toNamed(AppRoute.dashboard);
  }

  void gotoReportScreen() {
    Get.toNamed(AppRoute.report);
  }
}