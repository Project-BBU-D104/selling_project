import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/setting_controller.dart';

class PreferenceSection extends GetView<SettingController> {
  const PreferenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              onTap: () {
                Get.back();
                controller.changeLanguage('km', 'ភាសាខ្មែរ');
              },
            ),
            ListTile(
              leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
              title: const Text("English (US)"),
              onTap: () {
                Get.back();
                controller.changeLanguage('en', 'English (US)');
              },
            ),
          ],
        ),
      ),
    );
  }
}