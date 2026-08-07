import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/setting_controller.dart';

class UserProfileCard extends GetView<SettingController> {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}