import 'package:get/get.dart';
import 'package:selling_project/models/report/report_detail_model.dart';
import 'package:selling_project/models/report/report_model.dart';
import 'package:selling_project/services/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();

  var isLoading = false.obs;
  var reportSummary = Rxn<ReportSummaryModel>();
  var transactionsList = <SalesTransactionModel>[].obs;
  var selectedFilter = 'This Month'.obs; // Default filter

  @override
  void onInit() {
    super.onInit();
    fetchReport();
  }

  Future<void> fetchReport() async {
    isLoading.value = true;
    try {
      // 1. ទាញយក Sales Transactions ដោយផ្អែកលើ Selected Filter
      List<SalesTransactionModel> filteredSales = 
          await _reportService.getSalesData(selectedFilter.value);

      transactionsList.value = filteredSales;

      // 2. គណនា Summary (Total Sales, Net Profit, Orders, Items Sold)
      double totalRevenue = 0.0;
      double totalProfit = 0.0;
      int totalQty = 0;

      for (var item in filteredSales) {
        totalRevenue += item.grandTotal;
        totalProfit += item.profit;
        totalQty += item.totalQty;
      }

      // 3. Update Value ទៅកាន់ ReportSummaryModel
      reportSummary.value = ReportSummaryModel(
        totalSales: totalRevenue,
        netProfit: totalProfit,
        totalOrders: filteredSales.length,
        totalProductsSold: totalQty,
      );
    } catch (e) {
      print("Error in ReportController: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String newFilter) {
    if (selectedFilter.value != newFilter) {
      selectedFilter.value = newFilter;
      fetchReport(); // Re-fetch ទិន្នន័យភ្លាមៗពេលប្តូរ Filter
    }
  }

  void exportPDF() {
    Get.snackbar(
      "Export PDF", 
      "Generating PDF report for ${selectedFilter.value}...",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}