import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';

class SaleSuccessScreen extends StatelessWidget {
  const SaleSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text("Sales Completion",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // THANK YOU CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4F00FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "🎉 Thank You for Your Order!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Your order has been placed successfully, and\nyour payment has been received.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // CUSTOMER INFO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4F00FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer Info",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  SizedBox(height: 8),
                  Text("Transaction ID : #HP-ERP-2023-9942",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text("Customer : Jonathan Sterling",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text("Phone Number : 012 455 7897",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text("Location: California, CA 94025",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("October 24, 2023 . 14:42PM",
                        style: TextStyle(color: Colors.white70, fontSize: 10)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ITEMS SUMMARY CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ITEMS SUMMARY",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 11)),
                  const SizedBox(height: 10),
                  _buildSummaryItem("NVIDIA RTX 4090 OC Edition",
                      "1 unit x \$1,599.99", "\$1,599.99"),
                  _buildSummaryItem(
                      "Intel Core i9-13900k", "1 unit x \$589.00", "\$589.00"),
                  const Divider(height: 20),
                  _buildTotalRow("Subtotal", "\$2,618.99"),
                  _buildTotalRow("Tax(8.25%)", "\$216.06"),
                  _buildTotalRow("Total Amount", "\$2,704.10", isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // BUTTONS
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offAllNamed(AppRoute.sale);
                },
                icon: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.black),
                label: const Text("Begin New Sale",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E7EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text("Print Receipt",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F00FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String qtyText, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
              Text(qtyText,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          Text(price,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isBold ? 13 : 11,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 14 : 11,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
