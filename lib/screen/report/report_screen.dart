import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/report_controller.dart';
import 'package:selling_project/models/report/report_detail_model.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Reports & Analytics".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF003B6D),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: "Export PDF",
            onPressed: () => controller.exportPDF(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
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
                  Text(
                    "Sales Summary".tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedFilter.value,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: ['Today', 'This Week', 'This Month', 'This Year', 'All']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) controller.changeFilter(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. SUMMARY CARDS
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.35,
                children: [
                  _buildCard("Total Revenue".tr, currencyFormat.format(summary?.totalSales ?? 0), Icons.monetization_on_rounded, const Color(0xFF10B981)),
                  _buildCard("Net Profit".tr, currencyFormat.format(summary?.netProfit ?? 0), Icons.trending_up_rounded, const Color(0xFF3B82F6)),
                  _buildCard("Total Orders".tr, "${summary?.totalOrders ?? 0}", Icons.shopping_bag_rounded, const Color(0xFFF59E0B)),
                  _buildCard("Items Sold".tr, "${summary?.totalProductsSold ?? 0}", Icons.inventory_2_rounded, const Color(0xFF8B5CF6)),
                ],
              ),
              const SizedBox(height: 24),

              // 3. DETAILED TRANSACTIONS HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sales Transactions".tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  Text(
                    "${controller.transactionsList.length} Items",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. CLEAN TRANSACTION LIST (REPLACED TABLE WITH CARD LIST)
              _buildTransactionList(controller.transactionsList, currencyFormat, dateFormat),
            ],
          ),
        );
      }),
    );
  }

  // Summary Metric Card
  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Transaction List Builder (Modern UI)
  Widget _buildTransactionList(
    List<SalesTransactionModel> list,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
  ) {
    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text("No sales records found".tr, style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Row: Invoice ID & Grand Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long_rounded, size: 18, color: Color(0xFF003B6D)),
                      const SizedBox(width: 8),
                      Text(
                        "#${item.invoiceNo}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  Text(
                    currencyFormat.format(item.grandTotal),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF10B981)),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(height: 1, thickness: 0.6),
              ),
              // Bottom Row: Date & Qty/Profit Badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(item.date),
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Qty Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Qty: ${item.totalQty}",
                          style: TextStyle(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Profit Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Profit: ${currencyFormat.format(item.profit)}",
                          style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}