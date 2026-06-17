import 'package:get/get.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/services/customer_services.dart';

class CustomerController extends GetxController {
  final CustomerServices service = CustomerServices();
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCustomers();
  }

  void getCustomers(){

    loading.value = true;
    service.getCustomers().listen((data){
      customers.value = data;
      loading.value = false;
    });
    
  }
  Future<void> addCustomer() async {
    CustomerModel customer = CustomerModel(
      name: "Dara",
      phone: "012345678",
      email: "dara@gmail.com",
    );

    await service.addCustomer(customer);
  }

  Future<void> deleteCustomer(String id){
    return service.deleteCustomer(id);
  }
}