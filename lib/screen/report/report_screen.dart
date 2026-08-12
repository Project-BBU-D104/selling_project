import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/report_controller.dart';
import 'package:selling_project/screen/report/widget/report_sales_table_widget.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text("Reports & Analytics".tr),
        backgroundColor: const Color(0xFF003B6D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: "Export PDF",
            onPressed: () => controller.exportPDF(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchReport(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final summary = controller.reportSummary.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. FILTER HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sales Summary".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: controller.selectedFilter.value,
                    items: ['Today', 'This Week', 'This Month', 'This Year']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.changeFilter(val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. SUMMARY CARDS
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                children: [
                  _buildCard("Total Revenue".tr, currencyFormat.format(summary?.totalSales ?? 0), Icons.monetization_on_rounded, Colors.green),
                  _buildCard("Net Profit".tr, currencyFormat.format(summary?.netProfit ?? 0), Icons.trending_up_rounded, Colors.blue),
                  _buildCard("Total Orders".tr, "${summary?.totalOrders ?? 0}", Icons.shopping_bag_rounded, Colors.orange),
                  _buildCard("Items Sold".tr, "${summary?.totalProductsSold ?? 0}", Icons.inventory_2_rounded, Colors.purple),
                ],
              ),
              const SizedBox(height: 24),

              // 3. DETAILED SALES TRANSACTIONS TABLE
              Text("Sales Transactions".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ReportSalesTableWidget(transactions: controller.transactionsList),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: 20, child: Icon(icon, color: color, size: 20)),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}