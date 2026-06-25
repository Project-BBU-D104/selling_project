import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/controller/user_controller.dart';

class UserEditWidget extends StatelessWidget {
  final UserModel user;
  const UserEditWidget({super.key, required this.user});

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
        title: const Text('POS System', style: TextStyle(color: Color(0xFF002D62), fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit User Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF002D62))),
              const SizedBox(height: 4),
              const Text('Update credentials and access levels for enterprise accounts.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),
              
              // Profile Photo Box Layout
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF0064B0).withValues(alpha: 0.1),
                      child: const Icon(Icons.person, size: 40, color: Color(0xFF0064B0)),
                    ),
                    const SizedBox(height: 8),
                    const Text('Profile Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Text('JPG, GIF or PNG. Max size of 800K', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: () {}, child: const Text('Upload New')),
                        TextButton(onPressed: () {}, child: const Text('Remove', style: TextStyle(color: Colors.red))),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              _buildInputLabel('Full Name'),
              TextField(
                controller: ctr.fullNameController,
                decoration: _buildInputDecoration('Enter full name', Icons.person_outline),
              ),
              const SizedBox(height: 16),
              
              _buildInputLabel('Email Address'),
              TextField(
                controller: ctr.emailController, 
                decoration: _buildInputDecoration('Enter email address', Icons.mail_outline),
              ),
              const SizedBox(height: 16),
              
              _buildInputLabel('Role'),
              Obx(() => DropdownButtonFormField<String>(
                initialValue: ctr.selectedRole.value,
                isExpanded: true,
                decoration: _buildInputDecoration('', Icons.manage_accounts_outlined),
                items: ['Staff', 'Logistics Manager', 'Sales Associate', 'Support Tech', 'System Admin', 'Chief Admin'].map((r) {
                  return DropdownMenuItem(value: r, child: Text(r));
                }).toList(),
                onChanged: (val) => ctr.selectedRole.value = val!,
              )),
              const SizedBox(height: 16),
              
              _buildInputLabel('Department'),
              TextField(
                controller: ctr.departmentController, 
                decoration: _buildInputDecoration('Enter department', Icons.business_outlined),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info, color: Color(0xFF0064B0), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Administrative Privileges', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1F2937))),
                          SizedBox(height: 2),
                          Text('Changing the role to a non-admin level will immediately revoke access to global system settings and user management panels.', style: TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002D62),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => ctr.saveUpdatedUser(user.uid!),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text('Update User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFF374151))),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF4B5563), size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0064B0), width: 1.5),
      ),
    );
  }
}