import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/user_controller.dart';

class UserAddWidget extends StatelessWidget {
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

  UserAddWidget({super.key}) {
    controller.clearForm();
  }

  @override
  Widget build(BuildContext context) {
    // ពណ៌ចម្បងស្របតាមរូបភាព UI
    const Color primaryColor = Color(0xFF003354);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HardwarePro',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20, height: 1.1),
            ),
            Text(
              'Enterprise',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20, height: 1.1),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/admin_avatar.png'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Status Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add New User',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D233A)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(radius: 3, backgroundColor: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                'System Operational',
                                style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Provision access for a new team member.',
                      style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade400),
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),
                    _buildInputLabel('Full Name'),
                    TextFormField(
                      controller: controller.fullNameController,
                      decoration: _buildInputDecoration('e.g. Robert Jensen', Icons.person_outline),
                      validator: (value) => value!.trim().isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildInputLabel('Email Address'),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: _buildInputDecoration('r.jensen@hardwarepro.com', Icons.mail_outline),
                      validator: (value) => value!.trim().isEmpty ? 'Please enter email' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildInputLabel('Role'),
                    Obx(() => DropdownButtonFormField<String>(
                          initialValue: roleOptions.contains(controller.selectedRole.value)
                              ? controller.selectedRole.value
                              : 'Staff',
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          decoration: _buildInputDecoration('', Icons.manage_accounts_outlined),
                          items: roleOptions.map((role) {
                            return DropdownMenuItem(value: role, child: Text(role, style: const TextStyle(fontSize: 15)));
                          }).toList(),
                          onChanged: (val) => controller.selectedRole.value = val!,
                        )),
                    const SizedBox(height: 20),

                    // Department Input
                    _buildInputLabel('Department'),
                    TextFormField(
                      decoration: _buildInputDecoration('e.g. Logistics', Icons.business_outlined),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'System Status',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0D233A)),
                            ),
                            Text(
                              'Enable instant access',
                              style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(() => Switch(
                                  value: controller.isUserActive.value,
                                  activeThumbColor: Colors.white,
                                  activeTrackColor: primaryColor,
                                  inactiveTrackColor: Colors.grey.shade300,
                                  onChanged: (val) => controller.isUserActive.value = val,
                                )),
                            const SizedBox(width: 4),
                            const Text(
                              'Active',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003354)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  // Discard Button
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
                        'Discard',
                        style: TextStyle(color: Color(0xFF0D233A), fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                          controller.createUser();
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add_alt_1_outlined, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Create User',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
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