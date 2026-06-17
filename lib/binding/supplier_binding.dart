import 'package:get/get.dart';
import 'package:selling_project/controller/supplier_controller.dart';

class SupplierBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<SupplierController>(() => SupplierController(),
    );
  }
}