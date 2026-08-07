import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/setting_controller.dart';

class NotificationSection extends GetView<SettingController> {
  const NotificationSection({super.key});

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
    );
  }
}