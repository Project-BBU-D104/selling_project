import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';

class HomeController extends GetxController{

  void gotoCustomerScreen() {
    Get.toNamed(AppRoute.customer);
  }
}