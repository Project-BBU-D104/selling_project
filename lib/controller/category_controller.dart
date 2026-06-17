import 'package:get/get.dart';
import 'package:selling_project/models/category_model.dart';
import 'package:selling_project/services/category_services.dart';

class CategoryController extends GetxController {
  final CategoryServices service = CategoryServices();
  RxList<CategoryModel> category = <CategoryModel>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  void getCategories(){

    loading.value = true;
    service.getCategories().listen((data){
      category.value = data;
      loading.value = false;
    });
  }
  Future<void> addCategory() async {
    CategoryModel category = CategoryModel(
      name: "Helo Coca",
      description: "Hell world",
    );

    await service.addCategory(category);
  }

  Future<void> deleteCategory(String id){
    return service.deleteCategory(id);
  }
}