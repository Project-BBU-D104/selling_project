import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';

class LoginController extends GetxController {
  void onLoginPressed() {
    Get.offAllNamed(AppRoute.home);
  }
} 