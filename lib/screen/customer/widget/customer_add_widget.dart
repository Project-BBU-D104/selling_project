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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add Customer',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.account_circle, color: Colors.black, size: 30),
        //     onPressed: () {},
        //   ),
        //   const SizedBox(width: 8),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Customer Name', Icons.person, ctr.customerNameController, hintText: 'Enter customer name'),
            const SizedBox(height: 16),
            _buildCustomerTypeDropdown(ctr),
            const SizedBox(height: 16),
            
            _buildField('Phone Number', Icons.phone_outlined, ctr.phoneController, hintText: '+1 555-0000', keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildField('Email address', Icons.mail_outline, ctr.emailController, hintText: 'name@example.com', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildField('Address', Icons.location_on_outlined, ctr.addressController, hintText: 'Street, City ,State, Zip', maxLines: 3),
            const SizedBox(height: 16),
            
            // Status Checkbox Row
            GestureDetector(
              onTap: () => ctr.customerStatus.value = !ctr.customerStatus.value,
              child: Row(
                children: [
                  Obx(() => Icon(
                        ctr.customerStatus.value ? Icons.check_box : Icons.check_box_outline_blank,
                        color: Colors.black87,
                        size: 24,
                      )),
                  const SizedBox(width: 8),
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Obx(() => ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005288),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                child: ctr.loading.value
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'Save Customer',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerTypeDropdown(CustomerController ctr) {
    final List<String> customerTypes = ['General', 'Retail', 'Wholesale', 'VIP', 'Corporate'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Type',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: ctr.customerTypeController,
          builder: (context, value, child) {
            String? selectedValue = customerTypes.contains(value.text) ? value.text : null;

            return DropdownButtonFormField<String>(
              initialValue: selectedValue,
              hint: const Text(
                'Select customer type',
                style: TextStyle(color: Colors.black26, fontSize: 14),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.black87, size: 22),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF005288))),
              ),
              items: customerTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type, style: const TextStyle(fontSize: 14, color: Colors.black)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ctr.customerTypeController.text = newValue;
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildField(
    String label, 
    IconData icon, 
    TextEditingController controller, {
    String hintText = '',
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black87, size: 22),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF005288))),
          ),
        ),
      ],
    );
  }
}