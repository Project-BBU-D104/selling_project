import 'package:get/get.dart';
import 'package:selling_project/models/product_model.dart';
import 'package:selling_project/services/product_services.dart';

class ProductController extends GetxController {
  final ProductServices service = ProductServices();
  RxList<ProductModel> product = <ProductModel>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  void getProducts(){

    loading.value = true;
    service.getProducts().listen((data){
      product.value = data;
      loading.value = false;
    });
  }
  Future<void> addProduct() async {
    ProductModel product = ProductModel(
      name: "Helo Coca",
      price: 1000,
      categoryId: "1",
    );

    await service.addProduct(product);
  }

  Future<void> deleteProduct(String id){
    return service.deleteProduct(id);
  }
}