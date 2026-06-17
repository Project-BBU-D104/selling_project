import 'package:selling_project/models/payment_model.dart';
import 'package:selling_project/services/api_services.dart';
class PaymentServices {

  final ApiServices api = ApiServices();
  final String collection = "payments";

  // GET
  Stream<List<PaymentModel>> getPayments() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return PaymentModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addPayment(
      PaymentModel payment
  ) async {
    return await api.post(
      collection,
      payment.toJson()
    );
  }
  // UPDATE
  Future<void> updatePayment(
      PaymentModel brand
  ) async {
    await api.put(
      collection,
      brand.id!,
      brand.toJson()
    );
  }
  // DELETE
  Future<void> deletePayment(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}