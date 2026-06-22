import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import ត្រឹមត្រូវ (ដោះស្រាយ Error របស់អ្នក)
import 'package:selling_project/controller/customer_controller.dart';
import 'package:selling_project/models/customer_model.dart';

class CustomerEditWidget extends StatelessWidget {
  final CustomerModel customer;
  const CustomerEditWidget({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomerController>();
    ctr.setCustomer(customer);

    String formattedDate = 'Not updated yet';
    if (customer.updatedAt != null) {
      formattedDate = DateFormat('MMM dd, yyyy').format(customer.updatedAt!);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003366)),
          onPressed: () => Get.back(),
        ),
        title: const Text('Edit Customer', style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 8),
                  const Text('ACTIVE\nACCOUNT', style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, height: 1.1)),
                  const Spacer(),
                  Text(
                    'Last updated:\n$formattedDate', // បង្ហាញថ្ងៃខែពិតប្រាកដ និងស្វ័យប្រវត្ត
                    textAlign: TextAlign.end, 
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic, height: 1.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('Customer Name', Icons.person_outline, ctr.customerNameController),
                  const SizedBox(height: 16),
                  _buildField('Company Name', Icons.domain_outlined, ctr.addressController), 
                  const SizedBox(height: 16),
                  _buildField('Phone Number', Icons.phone_outlined, ctr.phoneController),
                  const SizedBox(height: 16),
                  _buildField('Email Address', Icons.mail_outline, ctr.emailController),
                  const SizedBox(height: 16),
                  _buildField('Shipping Address', Icons.location_on_outlined, ctr.addressController, maxLines: 3),
                  const SizedBox(height: 20),
                  
                  const Text('Customer Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
                  const SizedBox(height: 8),
                  
                  Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip(ctr, 'Standard'),
                      _buildChip(ctr, 'VIP', hasStar: true),
                      _buildChip(ctr, 'Wholesale'),
                      _buildChip(ctr, 'Internal'),
                    ],
                  )),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await ctr.updateCustomer(customer.id!);
                        Get.back();
                      },
                      icon: const Icon(Icons.save_outlined, color: Colors.white, size: 18),
                      label: const Text('Update Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005293), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(CustomerController ctr, String label, {bool hasStar = false}) {
    final isSelected = ctr.selectedCategory.value == label;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasStar) Icon(Icons.star, size: 14, color: isSelected ? Colors.white : Colors.grey),
          if (hasStar) const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF004B87),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF4B5563), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300)),
      onSelected: (selected) { if (selected) ctr.selectedCategory.value = label; },
    );
  }
}