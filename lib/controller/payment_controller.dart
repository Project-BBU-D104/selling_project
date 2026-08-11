import 'package:get/get.dart';
import 'package:selling_project/models/payment_model.dart';
import 'package:selling_project/services/payment_services.dart';

class PaymentController extends GetxController {
  final PaymentServices _service = PaymentServices();

  // Observable State Variables
  var payments = <PaymentModel>[].obs;
  var isLoading = false.obs;

  var searchQuery = ''.obs;
  var selectedDateFilter = 'All Dates'.obs;
  var selectedStatusFilter = 'All'.obs;
  var selectedMethodFilter = 'All'.obs;

  // Filter Options List
  final dateOptions = ['All Dates', 'Today', 'This Month'];
  final statusOptions = ['All', 'Paid', 'Pending', 'Failed'];
  final methodOptions = ['All', 'ABA PAY', 'Credit Card', 'Bank Transfer', 'Cash Riel'];

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  double get totalMTD {
    final now = DateTime.now();
    return payments.where((p) {
      final date = p.paymentDate?.toLocal();
      if (date == null) return false;
      return date.month == now.month && date.year == now.year;
    }).fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalYTD {
    final now = DateTime.now();
    return payments.where((p) {
      final date = p.paymentDate?.toLocal();
      if (date == null) return false;
      return date.year == now.year;
    }).fold(0.0, (sum, item) => sum + item.amount);
  }

  void fetchPayments() {
    isLoading.value = true;
    _service.getPayments().listen(
      (data) {
        payments.value = data;
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to load payments: $error");
      },
    );
  }

  List<PaymentModel> get filteredPayments {
    final query = searchQuery.value.toLowerCase().trim();
    final now = DateTime.now();

    return payments.where((p) {
      // 1. Filter Search Query (Invoice No, Customer Name, or Method)
      if (query.isNotEmpty) {
        final inv = p.invoiceNo?.toLowerCase() ?? '';
        final customer = p.customerName?.toLowerCase() ?? '';
        final method = p.paymentMethod.toLowerCase();
        
        final matchesQuery = inv.contains(query) || 
                             customer.contains(query) || 
                             method.contains(query);
        if (!matchesQuery) return false;
      }

      // 2. Filter Status
      if (selectedStatusFilter.value != 'All') {
        if (p.status.toLowerCase() != selectedStatusFilter.value.toLowerCase()) {
          return false;
        }
      }

      // 3. Filter Method
      if (selectedMethodFilter.value != 'All') {
        if (p.paymentMethod.toLowerCase() != selectedMethodFilter.value.toLowerCase()) {
          return false;
        }
      }

      // 4. Filter Date Range
      if (selectedDateFilter.value != 'All Dates') {
        final date = p.paymentDate.toLocal();
        
        if (selectedDateFilter.value == 'Today') {
          final isToday = date.day == now.day && 
                          date.month == now.month && 
                          date.year == now.year;
          if (!isToday) return false;
        } else if (selectedDateFilter.value == 'This Month') {
          final isThisMonth = date.month == now.month && date.year == now.year;
          if (!isThisMonth) return false;
        }
      }

      return true;
    }).toList();
  }

  // --- Filter State Modifiers ---
  void filterPayments(String query) => searchQuery.value = query;
  void changeDateFilter(String filter) => selectedDateFilter.value = filter;
  void changeStatusFilter(String filter) => selectedStatusFilter.value = filter;
  void changeMethodFilter(String filter) => selectedMethodFilter.value = filter;

  Future<void> addPayment(PaymentModel payment) async {
    try {
      await _service.addPayment(payment);
      Get.snackbar("Success", "Payment recorded successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to add payment: $e");
    }
  }

  Future<void> updatePayment(PaymentModel payment) async {
    try {
      await _service.updatePayment(payment);
      Get.snackbar("Success", "Payment updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update payment: $e");
    }
  }
}