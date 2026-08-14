import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/report/report_detail_model.dart';
import 'package:selling_project/models/report/report_model.dart';
import 'package:selling_project/services/pdf_services.dart';
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
      List<SalesTransactionModel> filteredSales = 
          await _reportService.getSalesData(selectedFilter.value);

      transactionsList.value = filteredSales;

      double totalRevenue = 0.0;
      double totalProfit = 0.0;
      int totalQty = 0;

      for (var item in filteredSales) {
        totalRevenue += item.grandTotal;
        totalProfit += item.profit;
        totalQty += item.totalQty;
      }

      reportSummary.value = ReportSummaryModel(
        totalSales: totalRevenue,
        netProfit: totalProfit,
        totalOrders: filteredSales.length,
        totalProductsSold: totalQty,
      );
    } catch (e) {
      print("Error in ReportController: $e");
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

  void changeFilter(String newFilter) {
    if (selectedFilter.value != newFilter) {
      selectedFilter.value = newFilter;
      fetchReport();
    }
  }

  Future<void> exportPDF() async {
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

    try {
      await PdfServices.generateAndExportPdf(
        filterTitle: selectedFilter.value,
        summary: reportSummary.value,
        transactions: transactionsList,
      );
    } catch (e) {
      print("Export PDF Error: $e");
      Get.snackbar(
        "Export Error",
        "Failed to generate PDF file: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }
}