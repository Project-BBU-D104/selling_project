import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/controller/user_controller.dart';

class UserEditWidget extends StatelessWidget {
  final UserModel user;
  final UserController controller = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  final List<String> roleOptions = [
    'Staff',
    'Logistics Manager',
    'Sales Associate',
    'Support Tech',
    'System Admin',
    'Chief Admin'
  ];

  final List<String> departmentOptions = [
    'Operations',
    'Logistics',
    'Sales',
    'Technical Support',
    'Management'
  ];

  UserEditWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF003354);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit User Profile',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Input
                    _buildInputLabel('Full Name'),
                    TextFormField(
                      controller: controller.fullNameController,
                      decoration: _buildInputDecoration('Full Name', Icons.person_outline),
                      validator: (value) => value!.trim().isEmpty ? 'Full name cannot be empty' : null,
                    ),
                    const SizedBox(height: 18),

                    // Email Address Input
                    _buildInputLabel('Email Address'),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: _buildInputDecoration('Email Address', Icons.mail_outline),
                      validator: (value) => value!.trim().isEmpty ? 'Email cannot be empty' : null,
                    ),
                    const SizedBox(height: 18),
                    _buildInputLabel('Role'),
                    Obx(() => DropdownButtonFormField<String>(
                          initialValue: roleOptions.contains(controller.selectedRole.value)
                              ? controller.selectedRole.value
                              : 'Staff',
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                          decoration: _buildInputDecoration('', Icons.shield_outlined),
                          items: roleOptions.map((role) {
                            return DropdownMenuItem(value: role, child: Text(role, style: const TextStyle(fontSize: 15)));
                          }).toList(),
                          onChanged: (val) => controller.selectedRole.value = val!,
                        )),
                    const SizedBox(height: 18),
                    _buildInputLabel('Department'),
                    DropdownButtonFormField<String>(
                      initialValue: departmentOptions.first,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                      decoration: _buildInputDecoration('', Icons.business_outlined),
                      items: departmentOptions.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept, style: const TextStyle(fontSize: 15)));
                      }).toList(),
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info, color: Color(0xFF0066A6), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Administrative Privileges',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A202C)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Changing the role to a non-admin level will immediately revoke access to global system settings and user management panels.',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0, top: 8.0),
            child: Column(
              children: [
                // 1. ប៊ូតុង Update User
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.saveUpdatedUser(user);
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Update User',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF4A5568), fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF4A5568)),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF003354), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}