import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/models/customer_model.dart';
import 'package:selling_project/screen/customer/widget/customer_edit_widget.dart';
import 'package:selling_project/controller/customer_controller.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomerController>();

    String formattedDate = '';
    if (customer.updatedAt != null) {
      formattedDate = DateFormat('dd-MMM-yyyy').format(customer.updatedAt!);
    } else if (customer.createdAt != null) {
      formattedDate = DateFormat('dd-MMM-yyyy').format(customer.createdAt!);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFD9D9D9),
                child: Icon(Icons.person, size: 30, color: Colors.black54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // 🔹 បង្ហាញប្រភេទ Customer (Customer Type Tag)
                    if (customer.customerType != null && customer.customerType!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF005288).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF005288), width: 0.8),
                        ),
                        child: Text(
                          customer.customerType!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF005288),
                          ),
                        ),
                      ),
                    ],

                    if (customer.email != null && customer.email!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        customer.email!,
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                    if (customer.phone != null && customer.phone!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        customer.phone!,
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Status Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: customer.status ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  customer.status ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: customer.status ? const Color(0xFF2E7D32) : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // More Actions Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                        Icon(Icons.edit_outlined, color: Color(0xFF005293), size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  customer.address ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (formattedDate.isNotEmpty)
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
            ],
          ),
        ],
      ),
    );
  }
}