import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/screen/customer/widget/customer_edit_widget.dart';
import 'package:selling_project/controller/customer_controller.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomerController>();

    Color tagBgColor = const Color(0xFFF3F4F6);
    Color tagTextColor = const Color(0xFF4B5563);
    String labelTag = customer.category ?? 'Standard';

    if (labelTag == 'VIP') {
      tagBgColor = const Color(0xFFF3E8FF);
      tagTextColor = const Color(0xFF7E22CE);
    } else if (labelTag == 'Wholesale') {
      tagBgColor = const Color(0xFFE0F2FE);
      tagTextColor = const Color(0xFF0369A1);
    } else if (labelTag == 'Internal') {
      tagBgColor = const Color(0xFFFEF3C7);
      tagTextColor = const Color(0xFFD97706);
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFE5E7EB),
                  child: Text(
                    customer.customerName.isNotEmpty ? customer.customerName[0].toUpperCase() : "?",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.customerName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customer.phone,
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    labelTag,
                    style: TextStyle(color: tagTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(), 
                      padding: const EdgeInsets.all(8),
                      icon: const Icon(Icons.edit_outlined, color: Color(0xFF005293), size: 20),
                      onPressed: () {
                        ctr.setCustomer(customer);
                        Get.to(() => CustomerEditWidget(customer: customer));
                      },
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Customer",
                          middleText: "Are you sure you want to delete ${customer.customerName} permanently?",
                          textConfirm: "Delete",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                          onConfirm: () async {
                            Get.back();
                            await ctr.deleteCustomer(customer.id!);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF3F4F6)),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Purchases', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(
                        '\$${customer.totalPurchases?.toStringAsFixed(2) ?? "0.00"}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: const Color(0xFFE5E7EB)),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Balance', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(
                        '\$${customer.balance?.toStringAsFixed(2) ?? "0.00"}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}