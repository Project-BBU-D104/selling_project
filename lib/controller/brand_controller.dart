import 'package:get/get.dart';
import 'package:selling_project/models/brand_model.dart';
import 'package:selling_project/services/brand_services.dart';

class BrandController extends GetxController {

  final BrandServices service = BrandServices();

  RxList<BrandModel> brands = <BrandModel>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBrands();
  }

  void getBrands() {
    loading.value = true;

    service.getBrands().listen((data) {
      brands.value = data;
      loading.value = false;
    });
  }

  Future<void> addTestBrand() async {

    final brand = BrandModel(
      name: "Apple",
      description: "Apple Brand",
      status: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await service.addBrand(brand);
  }

  Future<void> addBrand(
    BrandModel brand,
  ) async {
    await service.addBrand(brand);
  }

  Future<void> updateBrand(
    BrandModel brand,
  ) async {
    await service.updateBrand(brand);
  }

  Future<void> deleteBrand(
    String id,
  ) async {
    await service.deleteBrand(id);
  }
}