import 'package:get/get.dart';
import 'package:selling_project/models/supplier_model.dart';
import 'package:selling_project/services/supplier_services.dart';

class SupplierController extends GetxController {
  final SupplierServices service = SupplierServices();
  RxList<SupplierModel> suppliers = <SupplierModel>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSuppliers();
  }

  void getSuppliers(){

    loading.value = true;
    service.getSuppliers().listen((data){
      suppliers.value = data;
      loading.value = false;
    });
  }
  Future<void> addSupplier() async {
    SupplierModel supplier = SupplierModel(
      name: "Dara",
      phone: "012345678",
      email: "dara@gmail.com",
    );

    await service.addSupplier(supplier);
  }

  Future<void> deleteSupplier(String id){
    return service.deleteSupplier(id);
  }
}