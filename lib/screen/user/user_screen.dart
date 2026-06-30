import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/user_controller.dart';
import 'widget/user_card_widget.dart';
import 'widget/user_add_widget.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
        title: const Text('User Management', style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // របារស្វែងរក (Search Bar)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
              child: TextField(
                onChanged: (val) {
                  ctr.searchKeyword.value = val;
                  ctr.applyFilter();
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search system users...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          // ប្រព័ន្ធ Filter Tabs (Horizontal Scroll)
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All Users', 'Admins', 'Managers', 'Staff'].map((tab) {
                return Obx(() {
                  final isSelected = ctr.currentTab.value == tab;
                  return GestureDetector(
                    onTap: () => ctr.changeTab(tab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF004B87) : const Color(0xFFE5E7EB).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF4B5563), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          
          // បញ្ជីរាយនាម (Core Directory List View)
          Expanded(
            child: Obx(() {
              if (ctr.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (ctr.filteredUsers.isEmpty) {
                return const Center(child: Text('No internal users found.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ctr.filteredUsers.length,
                itemBuilder: (context, index) {
                  return UserCard(user: ctr.filteredUsers[index]);
                },
              );
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0064B0),
        onPressed: () {
          ctr.clearForm();
          Get.to(() => const UserAddWidget());
        },
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
    );
  }
}