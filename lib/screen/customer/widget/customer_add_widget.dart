import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/customer_controller.dart';

class CustomerAddWidget extends StatelessWidget {
  const CustomerAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomerController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctr.clearForm();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003366)),
          onPressed: () => Get.back(),
        ),
        title: const Text('Add Customer', style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Customer Name *', 'Enter full name', Icons.person_outline, ctr.customerNameController),
              const SizedBox(height: 16),
              _buildField('Phone Number *', '+1 555-0000', Icons.phone_outlined, ctr.phoneController),
              const SizedBox(height: 16),
              _buildField('Email Address', 'name@company.com', Icons.mail_outline, ctr.emailController),
              const SizedBox(height: 16),
              _buildField('Address', 'Street, City, State', Icons.location_on_outlined, ctr.addressController, maxLines: 3),
              const SizedBox(height: 20),
              
              const Text('Customer Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
              const SizedBox(height: 8),
              
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip(ctr, 'Standard', hasStar: true),
                  _buildChip(ctr, 'VIP'),
                  _buildChip(ctr, 'Wholesale'),
                  _buildChip(ctr, 'Internal'),
                ],
              )),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(() => ElevatedButton.icon(
                  onPressed: ctr.loading.value 
                      ? null 
                      : () async {
                          if (ctr.customerNameController.text.trim().isEmpty) {
                            Get.snackbar("Warning", "Customer Name is required", 
                              backgroundColor: Colors.orange.withValues(alpha: 0.2));
                            return;
                          }
                          await ctr.addCustomer();
                          
                        },
                  icon: ctr.loading.value 
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save_as_outlined, color: Colors.white, size: 18),
                  label: Text(ctr.loading.value ? 'Saving...' : 'Save Customer', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003E6B), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )),
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
                  child: const Text('Discard', style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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