import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/services/user_services.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  RxList<UserModel> users = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
  RxBool loading = false.obs;

  // Form State
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final departmentController = TextEditingController();
  var selectedRole = 'Staff'.obs;
  var isUserActive = true.obs;
  
  // Filter Tabs State
  var currentTab = 'All Users'.obs;
  var searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() {
    loading.value = true;
    _service.getUsers().listen((data) {
      users.value = data;
      applyFilter();
      loading.value = false;
    });
  }

  void applyFilter() {
    List<UserModel> temp = users;
    
    // ស្វែងរកតាមឈ្មោះ ឬអ៊ីមែល
    if (searchKeyword.value.isNotEmpty) {
      temp = temp.where((u) => 
        u.username!.toLowerCase().contains(searchKeyword.value.toLowerCase()) ||
        u.email!.toLowerCase().contains(searchKeyword.value.toLowerCase())
      ).toList();
    }

    // ត្រងតាមប្រភេទ Tab
    if (currentTab.value == 'Admins') {
      temp = temp.where((u) => u.role == 'System Admin' || u.role == 'Chief Admin').toList();
    } else if (currentTab.value == 'Managers') {
      temp = temp.where((u) => u.role!.contains('Manager')).toList();
    }

    filteredUsers.value = temp;
  }

  void changeTab(String tabName) {
    currentTab.value = tabName;
    applyFilter();
  }

  void setEditUser(UserModel user) {
    fullNameController.text = user.username ?? '';
    emailController.text = user.email ?? '';
    departmentController.text = user.department ?? '';
    selectedRole.value = user.role ?? 'Staff';
    isUserActive.value = user.status;
  }

  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    departmentController.clear();
    selectedRole.value = 'Staff';
    isUserActive.value = true;
  }

  Future<void> saveUpdatedUser(String uid) async {
    try {
      UserModel updated = UserModel(
        uid: uid,
        username: fullNameController.text.trim(),
        email: emailController.text.trim(),
        department: departmentController.text.trim(),
        role: selectedRole.value,
        status: isUserActive.value,
      );
      await _service.updateUser(updated);
      Get.back();
      Get.snackbar("Success", "User credentials modified", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> removeUser(String uid) async {
    try {
      await _service.deleteUser(uid);
      Get.snackbar("Deleted", "User removed from global directory", backgroundColor: Colors.black87, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}