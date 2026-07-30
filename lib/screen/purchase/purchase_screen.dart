import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/purchase_controller.dart';
import 'package:selling_project/screen/purchase/widget/purchase_add_widget.dart';
import 'package:selling_project/screen/purchase/widget/purchase_card_widget.dart';
import 'package:selling_project/screen/purchase/widget/purchase_edit_widget.dart';

class PurchaseScreen extends StatelessWidget {
  PurchaseScreen({super.key});

  final PurchaseController ctr = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
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
          "Purchase Management",
          style: TextStyle(color: Color(0xFF003B6D), fontWeight: FontWeight.bold, fontSize: 18),
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
            // Top Cards
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _statCard("Total Monthly", "\$${ctr.totalMonthly.value.toStringAsFixed(0)}", const Color(0xFF004B87), Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard("Pending", "${ctr.pendingOrdersCount.value} Orders", const Color(0xFF71A5C8), Colors.white),
                    ),
                  ],
                )),
            const SizedBox(height: 14),

            // Search Bar
            TextField(
              onChanged: (val) => ctr.changeSearchQuery(val), // 👈 កែត្រង់នេះ
              decoration: InputDecoration(
                hintText: "Search Purchase...",
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

            // Filter Buttons
            Row(
              children: [
                _filterButton("All Purchases"),
                const SizedBox(width: 8),
                _filterButton("Pending"),
                const SizedBox(width: 8),
                _filterButton("Completed"),
              ],
            ),
            const SizedBox(height: 14),

            // List Purchases
            Expanded(
              child: Obx(() {
                if (ctr.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctr.filteredPurchases.isEmpty) {
                  return const Center(child: Text("No purchases found."));
                }
                return ListView.builder(
                  itemCount: ctr.filteredPurchases.length,
                  itemBuilder: (context, index) {
                    final item = ctr.filteredPurchases[index];
                    return PurchaseCardWidget(
                      purchase: item,
                      onTap: () => Get.to(() => PurchaseEditWidget(purchase: item)),
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
        onPressed: () => Get.to(() => const PurchaseAddWidget()),
      ),
    );
  }

  Widget _statCard(String label, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.9))),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  Widget _filterButton(String title) {
    return Expanded(
      child: Obx(() {
        bool isSelected = ctr.selectedFilter.value == title;
        return GestureDetector(
          onTap: () => ctr.changeFilter(title), // 👈 កែត្រង់នេះ
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.shade600 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}