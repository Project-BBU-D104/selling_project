import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/setting_controller.dart';

class SignOutButton extends GetView<SettingController> {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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