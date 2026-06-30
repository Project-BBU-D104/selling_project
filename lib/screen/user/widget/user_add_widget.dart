import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/user_controller.dart';

class UserAddWidget extends StatelessWidget {
  const UserAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF002D62)),
          onPressed: () => Get.back(),
        ),
        title: const Text('POS System',
            style: TextStyle(
                color: Color(0xFF002D62),
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New User',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002D62))),
              const SizedBox(height: 4),
              const Text('Provision access for a new team member.',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),
              _buildInputLabel('Full Name'),
              TextField(
                controller: ctr.fullNameController,
                decoration: _buildInputDecoration(
                    'e.g. Roeun Narom', Icons.person_outline),
              ),
              const SizedBox(height: 16),
              _buildInputLabel('Email Address'),
              TextField(
                controller: ctr.emailController,
                decoration: _buildInputDecoration(
                    'r.narom@possystem.com', Icons.mail_outline),
              ),
              const SizedBox(height: 16),
              _buildInputLabel('Role'),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.manage_accounts_outlined,
                            color: Color(0xFF4B5563), size: 20),
                        const SizedBox(
                            width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: ctr.selectedRole.value,
                              isExpanded: true,
                              items: [
                                'Staff',
                                'Logistics Manager',
                                'Sales Associate',
                                'Support Tech',
                                'System Admin',
                                'Chief Admin'
                              ].map((r) {
                                return DropdownMenuItem(
                                    value: r, child: Text(r));
                              }).toList(),
                              onChanged: (val) => ctr.selectedRole.value = val!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              _buildInputLabel('Department'),
              TextField(
                controller: ctr.departmentController,
                decoration: _buildInputDecoration(
                    'e.g. Logistics', Icons.business_outlined),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('System Status',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Enable instant access',
                          style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  Obx(() => Row(
                        children: [
                          Switch(
                            value: ctr.isUserActive.value,
                            activeThumbColor: const Color(0xFF002D62),
                            onChanged: (val) => ctr.isUserActive.value = val,
                          ),
                          Text(ctr.isUserActive.value ? 'Active' : 'Inactive',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Discard',
                      style: TextStyle(color: Color(0xFF4B5563))),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    Get.snackbar("Success", "User provision request processed",
                        backgroundColor: Colors.green, colorText: Colors.white);
                  },
                  icon: const Icon(Icons.person_add_alt_1,
                      color: Colors.white, size: 18),
                  label: const Text('Create User',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002D62),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
              fontSize: 14)),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }
}
