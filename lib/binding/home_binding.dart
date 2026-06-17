import 'package:get/get.dart';
import 'package:selling_project/controller/home_controller.dart';

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(),
    );
  }
}