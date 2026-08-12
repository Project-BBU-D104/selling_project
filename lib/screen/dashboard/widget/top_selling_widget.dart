import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/dashboard_controller.dart';

class TopSellingWidget extends GetView<DashboardController> {
  const TopSellingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          // Header + Filter Buttons (កែសម្រួលដើម្បីបាត់ Overflow)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Title (ប្រើ Flexible ដើម្បីការពារការទប់ Space ជួរ)
              const Flexible(
                child: Text(
                  'Top Selling Products',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              // 2. Filter Buttons Container
              Obx(() => Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ['Week', 'Month', 'Year'].map((filter) {
                    bool isSelected = controller.selectedFilter.value == filter;
                    return GestureDetector(
                      onTap: () => controller.changeFilter(filter),
                      child: Container(
                        // ✅ កាត់បន្ថយ padding ដើម្បីសមស្របតាមទំហំអេក្រង់
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: isSelected
                              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                              : [],
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 11, // ✅ បន្ថយទំហំ Font Size
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),

          // Table Header
          const Row(
            children: [
              Expanded(flex: 3, child: Text('PRODUCT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)))),
              Expanded(flex: 1, child: Text('QTY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('REVENUE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)), textAlign: TextAlign.right)),
              Expanded(flex: 2, child: Text('LAST SOLD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)), textAlign: TextAlign.right)),
            ],
          ),
          const Divider(height: 16),

          // Dynamic Table Rows (ជាមួយ Null Safety)
          Obx(() {
            if (controller.topProducts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'No top selling products found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return Column(
              children: controller.topProducts.map((item) {
                final String name = item['product_name']?.toString() ?? 'N/A';
                final String qty = item['qty_sold']?.toString() ?? '0';
                final double revenue = (item['revenue'] ?? 0.0).toDouble();
                final String lastSold = item['last_sold']?.toString() ?? 'N/A';

                return _buildTableRow(name, qty, '\$${revenue.toStringAsFixed(0)}', lastSold);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(String product, String qty, String revenue, String lastSold) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  product,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  qty,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  revenue,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  lastSold,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
      ],
    );
  }
}