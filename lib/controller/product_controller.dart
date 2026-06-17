import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/product_model.dart';
import 'package:selling_project/services/product_services.dart';

class ProductController extends GetxController {
  final ProductServices service = ProductServices();
  RxList<ProductModel> product = <ProductModel>[].obs;
  RxBool loading = false.obs;

  final formKey = GlobalKey<FormState>();

final nameCtrl = TextEditingController();
final priceCtrl = TextEditingController();

final selectedCategoryId = RxnString();
final selectedCategoryName = RxnString();

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }
  
@override
void onClose() {
  nameCtrl.dispose();
  priceCtrl.dispose();
  super.onClose();
}
  void getProducts(){

    loading.value = true;
    service.getProducts().listen((data){
      product.value = data;
      loading.value = false;
    });
  }

Future<void> addProduct(
  ProductModel product
) async {
  await service.addProduct(product);
}

  Future<void> deleteProduct(String id){
    return service.deleteProduct(id);
  }
}