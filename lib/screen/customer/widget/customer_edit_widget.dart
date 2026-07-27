import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/customer_controller.dart';
import 'package:selling_project/models/customer_model.dart';

class CustomerEditWidget extends StatelessWidget {
  final CustomerModel customer;
  const CustomerEditWidget({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomerController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctr.setCustomer(customer);
    });

    String formattedDate = 'Not updated yet';
    if (customer.updatedAt != null) {
      formattedDate = DateFormat('MMM dd, yyyy HH:mm').format(customer.updatedAt!);
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
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: ctr.customerStatus.value ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE), 
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 10, color: ctr.customerStatus.value ? const Color(0xFF2E7D32) : Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    ctr.customerStatus.value ? 'ACTIVE\nACCOUNT' : 'INACTIVE\nACCOUNT', 
                    style: TextStyle(
                      fontSize: 11, 
                      color: ctr.customerStatus.value ? const Color(0xFF2E7D32) : Colors.red, 
                      fontWeight: FontWeight.bold, 
                      height: 1.1
                    )
                  ),
                  const Spacer(),
                  Text(
                    'Last updated:\n$formattedDate',
                    textAlign: TextAlign.end, 
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic, height: 1.2),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),

            // Form Inputs
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('Customer Name *', Icons.person_outline, ctr.customerNameController),
                  const SizedBox(height: 16),
                  _buildField('Phone Number', Icons.phone_outlined, ctr.phoneController),
                  const SizedBox(height: 16),
                  _buildField('Email Address', Icons.mail_outline, ctr.emailController),
                  const SizedBox(height: 16),
                  _buildField('Address', Icons.location_on_outlined, ctr.addressController, maxLines: 3),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Account Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
                      Obx(() => Switch(
                        value: ctr.customerStatus.value,
                        activeColor: const Color(0xFF003366),
                        onChanged: (val) => ctr.customerStatus.value = val,
                      )),
                    ],
                  ),
                  
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
                                  backgroundColor: Colors.orange.withOpacity(0.2));
                                return;
                              }
                              if (customer.id != null) {
                                await ctr.updateCustomer(customer.id!);
                              }
                            },
                      icon: ctr.loading.value
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save_outlined, color: Colors.white, size: 18),
                      label: Text(ctr.loading.value ? 'Updating...' : 'Update Customer', 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005293), 
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
}