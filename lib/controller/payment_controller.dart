import 'package:get/get.dart';
import 'package:selling_project/models/payment_model.dart';
import 'package:selling_project/services/payment_services.dart';

class PaymentController extends GetxController {
  final PaymentServices _service = PaymentServices();

  var payments = <PaymentModel>[].obs;
  var filteredPayments = <PaymentModel>[].obs;
  var isLoading = false.obs;

  var totalMTD = 142850.00.obs;
  var totalYTD = 142850.00.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  void fetchPayments() {
    isLoading.value = true;
    _service.getPayments().listen((data) {
      payments.value = data;
      filteredPayments.value = data;
      isLoading.value = false;
    });
  }

  void filterPayments(String query) {
    if (query.isEmpty) {
      filteredPayments.value = payments;
    } else {
      filteredPayments.value = payments.where((p) {
        final inv = p.invoiceNo?.toLowerCase() ?? '';
        final method = p.paymentMethod.toLowerCase();
        return inv.contains(query.toLowerCase()) || method.contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<void> addPayment(PaymentModel payment) async {
    await _service.addPayment(payment);
  }

  Future<void> updatePayment(PaymentModel payment) async {
    await _service.updatePayment(payment);
  }

  Future<void> deletePayment(String id) async {
    await _service.deletePayment(id);
  }
}