import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/supplier_controller.dart';
import 'package:selling_project/models/supplier_model.dart';

class SupplierAdd extends StatelessWidget {
  const SupplierAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<SupplierController>();

    final nameController = TextEditingController();
    final companyController = TextEditingController();
    final contactController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF003865)), onPressed: () => Get.back()),
        title: const Text('Add New Supplier', style: TextStyle(color: Color(0xFF003865), fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Supplier Name *', nameController, Icons.business),
              _buildField('Company Name', companyController, Icons.corporate_fare),
              _buildField('Contact Person', contactController, Icons.person_outline),
              _buildField('Phone Number *', phoneController, Icons.phone, keyboardType: TextInputType.phone),
              _buildField('Email Address *', emailController, Icons.mail_outline, keyboardType: TextInputType.emailAddress),
              _buildField('Address Description', addressController, Icons.location_on_outlined, maxLines: 2),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                          Get.snackbar('Missing Data', 'Name and Phone inputs cannot be empty.', backgroundColor: Colors.orange);
                          return;
                        }

                        await ctr.addSupplier(SupplierModel(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          email: emailController.text.trim(),
                          companyName: companyController.text.trim(),
                          contactPerson: contactController.text.trim(),
                          address: addressController.text.trim(),
                          status: true,
                          createdAt: DateTime.now(),
                        ));
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003865), padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Save Supplier', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}