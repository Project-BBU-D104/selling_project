import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/controller/product_controller.dart'; 

class ProductBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<BrandController>(() => BrandController());
  }
}