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
                      if (customer.phone != null && customer.phone!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.phone_outlined, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              customer.phone!,
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                      if (customer.email != null && customer.email!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                customer.email!,
                                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: customer.status ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    customer.status ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: customer.status ? const Color(0xFF2E7D32) : Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF4B5563)),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.to(() => CustomerEditWidget(customer: customer));
                    } else if (value == 'delete') {
                      Get.defaultDialog(
                        title: "Delete Customer",
                        middleText: "Are you sure you want to delete ${customer.customerName}?",
                        textConfirm: "Delete",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        onConfirm: () async {
                          Get.back();
                          if (customer.id != null) {
                            await ctr.deleteCustomer(customer.id!);
                          }
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, color: Color(0xFF005293), size: 20),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Color(0xFF111827))),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (customer.address != null && customer.address!.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: Color(0xFFF3F4F6)),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      customer.address!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}