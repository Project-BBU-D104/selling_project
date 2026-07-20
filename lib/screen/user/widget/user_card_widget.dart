import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/user_controller.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/screen/user/widget/user_edit_widget.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    const Color primaryColor = Color(0xFF003354);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Profile Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE2ECF7),
            backgroundImage: (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                ? NetworkImage(user.imageUrl!)
                : null,
            child: (user.imageUrl == null || user.imageUrl!.isEmpty)
                ? Text(
                    user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                    style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(user.role, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),

          // Edit Button
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () {
              controller.setEditUser(user);
              Get.to(() => UserEditWidget(user: user));
            },
          ),

          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              if (user.id != null) {
                controller.removeUser(user.id!);
              }
            },
          ),
        ],
      ),
    );
  }
}