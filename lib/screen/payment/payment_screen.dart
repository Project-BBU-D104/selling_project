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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Payment management",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Total Revenue Cards
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _revenueCard("Total Revenue (MTD)", "\$${ctr.totalMTD.value.toStringAsFixed(2)}"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _revenueCard("Total Revenue (YTD)", "\$${ctr.totalYTD.value.toStringAsFixed(2)}"),
                    ),
                  ],
                )),
            const SizedBox(height: 14),

            // Search Bar
            TextField(
              onChanged: (val) => ctr.filterPayments(val),
              decoration: InputDecoration(
                hintText: "Search Invoices or Customers..",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip("All Dates", isSelected: true),
                  const SizedBox(width: 8),
                  _filterChip("Status: All"),
                  const SizedBox(width: 8),
                  _filterChip("Method: All"),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Payments List
            Expanded(
              child: Obx(() {
                if (ctr.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctr.filteredPayments.isEmpty) {
                  return const Center(child: Text("No payments found."));
                }
                return ListView.builder(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF003B6D),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () => Get.to(() => const PaymentAddWidget()),
      ),
    );
  }

  Widget _revenueCard(String title, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF005288)),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF71C2FF) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}