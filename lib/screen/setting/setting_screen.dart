import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.put(SettingController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "System Settings",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFFE9ECEF),
                            backgroundImage: controller.userProfileImage.value.isNotEmpty
                                ? NetworkImage(controller.userProfileImage.value)
                                : null,
                            child: controller.userProfileImage.value.isEmpty
                                ? const Icon(Icons.person, size: 36, color: Colors.black54)
                                : null,
                          )),
                      Positioned(
                        bottom: 0,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              controller.userName.value,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                            )),
                        const SizedBox(height: 3),
                        Obx(() => Text(
                              controller.userEmail.value,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            )),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Obx(() => Text(
                                controller.userRole.value,
                                style: const TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.w600),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader("PREFERENCES"),
            const SizedBox(height: 8),

            //Preferences Group (Dark Mode & Language Selector)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4)
                ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                        secondary: const Icon(Icons.dark_mode_outlined, color: Colors.black54),
                        title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w500)),
                        value: controller.isDarkMode.value,
                        onChanged: controller.toggleDarkMode,
                        activeThumbColor: Colors.blueAccent,
                      )),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  
                  // Language
                  ListTile(
                    leading: const Icon(Icons.language_outlined, color: Colors.black54),
                    title: const Text("Language", style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Obx(() => Text(
                          controller.selectedLanguage.value,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        )),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    onTap: () => _showLanguageBottomSheet(context, controller),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader("NOTIFICATIONS & ALERTS"),
            const SizedBox(height: 8),

            // Notifications
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                        secondary: const Icon(Icons.notifications_active_outlined, color: Colors.black54),
                        title: const Text("Push Notifications", style: TextStyle(fontWeight: FontWeight.w500)),
                        value: controller.pushNotifications.value,
                        onChanged: controller.togglePushNotifications,
                        activeThumbColor: Colors.green,
                      )),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  Obx(() => SwitchListTile(
                        secondary: const Icon(Icons.email_outlined, color: Colors.black54),
                        title: const Text("Email Alerts", style: TextStyle(fontWeight: FontWeight.w500)),
                        value: controller.emailAlerts.value,
                        onChanged: controller.toggleEmailAlerts,
                        activeThumbColor: Colors.green,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sign Out
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _showSignOutDialog(context, controller),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, SettingController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Language",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Text("🇰🇭", style: TextStyle(fontSize: 24)),
              title: const Text("ភាសាខ្មែរ (Khmer)"),
              onTap: () => controller.changeLanguage('km', 'ភាសាខ្មែរ'),
            ),
            ListTile(
              leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
              title: const Text("English (US)"),
              onTap: () => controller.changeLanguage('en', 'English (US)'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, SettingController controller) {
    Get.defaultDialog(
      title: "Sign Out",
      middleText: "Are you sure you want to sign out from the system?",
      textConfirm: "Yes, Sign Out",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color.fromARGB(255, 8, 8, 8),
      onConfirm: () {
        Get.back();
        controller.signOut();
      },
    );
  }
}