import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';

class BrandBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<BrandController>(() => BrandController(),
    );
  }
}