import 'package:get/get.dart';
import 'package:selling_project/controller/user_controller.dart';

class UserBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController(),
    );
  }
}