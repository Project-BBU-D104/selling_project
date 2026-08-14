import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/report/report_detail_model.dart';
import 'package:selling_project/models/report/report_model.dart';
import 'package:selling_project/services/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();

  var isLoading = false.obs;
  var reportSummary = Rxn<ReportSummaryModel>();
  var transactionsList = <SalesTransactionModel>[].obs;
  
  var selectedFilter = 'This Week'.obs; 

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
      print("❌ Error in ReportController: $e");
      Get.snackbar(
        "Error",
        "Failed to load report data: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 4. មុខងារផ្លាស់ប្តូរ Filter
  void changeFilter(String newFilter) {
    if (selectedFilter.value != newFilter) {
      selectedFilter.value = newFilter;
      fetchReport();
    }
  }

  // 5. មុខងារ Export PDF
  void exportPDF() {
    if (transactionsList.isEmpty) {
      Get.snackbar(
        "Warning",
        "No data available to export PDF",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return;
    }

    Get.snackbar(
      "Export PDF", 
      "Generating PDF report for ${selectedFilter.value}...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade900,
      icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
    );
  }
}