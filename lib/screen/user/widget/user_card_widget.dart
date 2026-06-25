import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/controller/user_controller.dart';
import 'user_edit_widget.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<UserController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
            backgroundColor: const Color(0xFFE5E7EB),
            child: user.photoUrl == null 
                ? const Icon(Icons.person, color: Colors.grey) 
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.username ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: user.status ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.status ? 'ACTIVE' : 'INACTIVE',
                        style: TextStyle(color: user.status ? const Color(0xFF15803D) : const Color(0xFF4B5563), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${user.role} • ${user.department}', style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF0064B0)),
                onPressed: () {
                  ctr.setEditUser(user);
                  Get.to(() => UserEditWidget(user: user));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Confirm Delete",
                    middleText: "Remove ${user.username} from enterprise access?",
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      Get.back();
                      ctr.removeUser(user.uid!);
                    }
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}