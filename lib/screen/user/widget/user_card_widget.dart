import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/controller/user_controller.dart';
import 'package:selling_project/screen/user/widget/user_edit_widget.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final UserController controller = Get.find<UserController>();

  UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // កំណត់ពណ៌ទៅតាមស្ថានភាព Active ឬ Inactive
    final Color statusBgColor = user.status ? const Color(0xFFE8F8F0) : const Color(0xFFEEEEEE);
    final Color statusTextColor = user.status ? const Color(0xFF2D9A68) : const Color(0xFF757575);
    final String statusText = user.status ? 'ACTIVE' : 'INACTIVE';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // ឱ្យវាដម្រឹមទៅខាងលើស្មើគ្នាពេលទិន្នន័យវែង
          children: [
            // ១. ផ្នែករូបភាពអ្នកប្រើប្រាស់ (Circle Avatar)
            Center(
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.blueGrey.shade50,
                child: Text(
                  user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003354)),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ២. ផ្នែកព័ត៌មានកណ្តាល (Name, Status, Role, Email, Phone)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // ឈ្មោះអ្នកប្រើប្រាស់
                      Flexible(
                        child: Text(
                          user.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF1A202C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ស្លាកបង្ហាញស្ថានភាព (Status Badge)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Role និង Department
                  Text(
                    '${user.role} • Operations',
                    style: const TextStyle(
                      color: Color(0xFF003354),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 🟢 បង្ហាញអុីមែល (Gmail)
                  if (user.email != null && user.email!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.mail_outline, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user.email!,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 🟢 បង្ហាញលេខទូរស័ព្ទ (Phone)
                  if (user.phone != null && user.phone!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            user.phone!,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // ៣. ផ្នែកប៊ូតុងសកម្មភាពខាងស្តាំបង្អស់ (Actions Column)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ប៊ូតុង Edit (រូបប៊ិចពណ៌ខៀវ)
                InkWell(
                  onTap: () {
                    controller.setEditUser(user);
                    Get.to(() => UserEditWidget(user: user));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF0066A6),
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // ប៊ូតុង Delete (រូបធុងសំរាមពណ៌ក្រហម)
                InkWell(
                  onTap: () {
                    Get.defaultDialog(
                      title: "Confirm Delete",
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      middleText: "Are you sure you want to delete this user?",
                      textConfirm: "Delete",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      onConfirm: () {
                        controller.removeUser(user.id ?? '');
                        Get.back();
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.delete_outline,
                      color: Color(0xFFE53E3E),
                      size: 18,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}