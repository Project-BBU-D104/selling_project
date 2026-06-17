import 'package:get/get.dart';
import 'package:selling_project/controller/category_controller.dart'; 

class CategoryBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController(),
    );
  }
}