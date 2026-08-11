import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/payment_controller.dart';
import 'package:selling_project/screen/payment/widget/payment_add_widget.dart';
import 'package:selling_project/screen/payment/widget/payment_card_widget.dart';
import 'package:selling_project/screen/payment/widget/payment_edit_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(PaymentController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Payment Management",
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Total Revenue Cards
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _revenueCard(
                        title: "Total Revenue (MTD)",
                        amount: "\$${ctr.totalMTD.toStringAsFixed(2)}",
                        icon: Icons.calendar_view_month_rounded,
                        accentColor: const Color(0xFF005288),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _revenueCard(
                        title: "Total Revenue (YTD)",
                        amount: "\$${ctr.totalYTD.toStringAsFixed(2)}",
                        icon: Icons.analytics_rounded,
                        accentColor: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              onChanged: (val) => ctr.filterPayments(val),
              decoration: InputDecoration(
                hintText: "Search Invoices, Customers...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF003B6D), width: 1.5),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip(
                        label: ctr.selectedDateFilter.value,
                        isSelected: ctr.selectedDateFilter.value != 'All Dates',
                        onTap: () => _showFilterDialog(
                          context,
                          title: "Filter by Date",
                          options: ctr.dateOptions,
                          currentValue: ctr.selectedDateFilter.value,
                          onSelect: (val) => ctr.changeDateFilter(val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: "Status: ${ctr.selectedStatusFilter.value}",
                        isSelected: ctr.selectedStatusFilter.value != 'All',
                        onTap: () => _showFilterDialog(
                          context,
                          title: "Filter by Status",
                          options: ctr.statusOptions,
                          currentValue: ctr.selectedStatusFilter.value,
                          onSelect: (val) => ctr.changeStatusFilter(val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: "Method: ${ctr.selectedMethodFilter.value}",
                        isSelected: ctr.selectedMethodFilter.value != 'All',
                        onTap: () => _showFilterDialog(
                          context,
                          title: "Filter by Method",
                          options: ctr.methodOptions,
                          currentValue: ctr.selectedMethodFilter.value,
                          onSelect: (val) => ctr.changeMethodFilter(val),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),

            // Payments List
            Expanded(
              child: Obx(() {
                if (ctr.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctr.filteredPayments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          "No payments found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ctr.filteredPayments.length,
                  itemBuilder: (context, index) {
                    final item = ctr.filteredPayments[index];
                    return PaymentCardWidget(
                      payment: item,
                      onTap: () => Get.to(() => PaymentEditWidget(payment: item)),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF003B6D),
        elevation: 3,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        label: const Text(
          "Add Payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => Get.to(() => const PaymentAddWidget()),
      ),
    );
  }

  Widget _revenueCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
              Icon(icon, size: 18, color: accentColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003B6D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelect,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 12),
            const Divider(),
            ...options.map((opt) => ListTile(
                  title: Text(
                    opt,
                    style: TextStyle(
                      fontWeight: opt == currentValue ? FontWeight.bold : FontWeight.normal,
                      color: opt == currentValue ? const Color(0xFF003B6D) : Colors.black87,
                    ),
                  ),
                  trailing: opt == currentValue
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF003B6D))
                      : null,
                  onTap: () {
                    onSelect(opt);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }
}