import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';
import 'package:selling_project/controller/product_controller.dart'; 

class ProductBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<BrandController>(() => BrandController());
  }
}