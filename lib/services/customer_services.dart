import 'package:selling_project/services/api_services.dart';
import 'package:selling_project/models/customer_model.dart';
class CustomerServices {

  final ApiServices api = ApiServices();
  final String collection = "customers";

  // GET
  Stream<List<CustomerModel>> getCustomers() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return CustomerModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
Future<CustomerModel?> getCustomerById(
  String id,
) async {
  final data =
      await api.getById(
        "customers",
        id,
      );

  if (data == null) return null;

  return CustomerModel.fromJson(
    data,
    data["id"],
  );
}


  // POST
  Future<String> addCustomer(
      CustomerModel customer
  ) async {
    return await api.post(
      collection,
      customer.toJson()
    );
  }
  // UPDATE
  Future<void> updateCustomer(
      CustomerModel customer
  ) async {
    await api.put(
      collection,
      customer.id!,
      customer.toJson()
    );
  }
  // DELETE
  Future<void> deleteCustomer(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}