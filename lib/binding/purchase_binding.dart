import 'package:get/get.dart';
import 'package:selling_project/controller/purchase_controller.dart';

class PurchaseBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PurchaseController>(() => PurchaseController(),
    );
  }
}