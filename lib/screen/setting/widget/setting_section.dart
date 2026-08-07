import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/setting_controller.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.find<SettingController>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          //Dark Mode
          Obx(() => SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text("Dark Mode"),
                value: controller.isDarkMode.value,
                onChanged: (value) => controller.toggleDarkMode(value),
              )),
          const Divider(height: 1, indent: 16, endIndent: 16),
          
          //Push Notifications
          Obx(() => SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: const Text("Push Notifications"),
                value: controller.pushNotifications.value,
                onChanged: (value) => controller.togglePushNotifications(value),
              )),
        ],
      ),
    );
  }
}