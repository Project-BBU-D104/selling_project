import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selling_project/controller/user_controller.dart';

class UserAddWidget extends StatelessWidget {
  final UserController controller = Get.find<UserController>();

  UserAddWidget({super.key}) {
    controller.clearForm();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF003354);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Add New User', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Provision access for a new team member.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Obx(() {
                    return CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFFE2ECF7),
                      backgroundImage: controller.selectedImage.value != null
                          ? FileImage(controller.selectedImage.value!)
                          : null,
                      child: controller.selectedImage.value == null
                          ? const Icon(Icons.person, size: 45, color: primaryColor)
                          : null,
                    );
                  }),
                  const SizedBox(height: 8),
                  const Text('Profile Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('JPG, GIF or PNG. Max size of 800K', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => _showPickerModal(context),
                        child: const Text('Upload New'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => controller.removeImage(),
                        child: const Text('Remove', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Full Name', controller.fullNameController, Icons.person_outline),
            const SizedBox(height: 12),
            _buildTextField('Email Address', controller.emailController, Icons.email_outlined),
            const SizedBox(height: 12),
            _buildTextField('Phone Number', controller.phoneController, Icons.phone_outlined),
            const SizedBox(height: 12),
            _buildTextField('Password', controller.passwordController, Icons.lock_outline, isPassword: true),
            const SizedBox(height: 12),
            const Text('Role', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            Obx(() => DropdownButtonFormField<String>(
                  initialValue: controller.selectedRole.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: controller.roleOptions.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedRole.value = val;
                  },
                )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('System Status (Active)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Obx(() => Switch(
                      value: controller.isUserActive.value,
                      activeThumbColor: primaryColor,
                      onChanged: (val) => controller.isUserActive.value = val,
                    )),
              ],
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Discard'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: controller.loading.value ? null : () => controller.createUser(),
                        child: controller.loading.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Create User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController, IconData icon, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: textController,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  void _showPickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () { controller.pickImage(ImageSource.gallery); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Camera'), onTap: () { controller.pickImage(ImageSource.camera); Navigator.pop(context); }),
          ],
        ),
      ),
    );
  }
}