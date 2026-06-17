import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';

class SaleBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<SaleController>(() => SaleController(),
    );
  }
}