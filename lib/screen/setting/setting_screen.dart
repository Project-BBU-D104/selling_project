import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/setting_controller.dart';
import 'package:selling_project/screen/setting/widget/user_profile_card.dart';
import 'package:selling_project/screen/setting/widget/preference_section.dart';
import 'package:selling_project/screen/setting/widget/notification_section.dart';
import 'package:selling_project/screen/setting/widget/sign_out_button.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());

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
            const UserProfileCard(),
            const SizedBox(height: 24),
            _buildSectionHeader("PREFERENCES"),
            const SizedBox(height: 8),
            const PreferenceSection(),
            const SizedBox(height: 24),
            _buildSectionHeader("NOTIFICATIONS & ALERTS"),
            const SizedBox(height: 8),
            const NotificationSection(),
            const SizedBox(height: 32),
            const SignOutButton(),
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
}