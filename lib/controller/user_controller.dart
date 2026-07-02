import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/services/user_services.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  RxList<UserModel> users = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
  RxBool loading = false.obs;

  // Form Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  var selectedRole = 'Staff'.obs;
  var isUserActive = true.obs;

  // Tabs Filter State
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

    if (searchKeyword.value.isNotEmpty) {
      temp = temp
          .where((u) =>
              u.fullName.toLowerCase().contains(searchKeyword.value.toLowerCase()) ||
              (u.email ?? '').toLowerCase().contains(searchKeyword.value.toLowerCase()))
          .toList();
    }

    if (currentTab.value == 'Admins') {
      temp = temp.where((u) => u.role == 'System Admin' || u.role == 'Chief Admin').toList();
    } else if (currentTab.value == 'Managers') {
      temp = temp.where((u) => u.role.contains('Manager')).toList();
    } else if (currentTab.value == 'Staff') {
      temp = temp.where((u) => u.role == 'Staff').toList();
    }

    filteredUsers.value = temp;
  }

  void changeTab(String tabName) {
    currentTab.value = tabName;
    applyFilter();
  }

  void setEditUser(UserModel user) {
    fullNameController.text = user.fullName;
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
    passwordController.text = user.password;
    selectedRole.value = user.role;
    isUserActive.value = user.status;
  }

  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    selectedRole.value = 'Staff';
    isUserActive.value = true;
  }

  Future<void> createUser() async {
    try {
      loading.value = true;
      UserModel newUser = UserModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        password: passwordController.text.trim(),
        role: selectedRole.value,
        status: isUserActive.value,
      );

      await _service.addUser(newUser);
      clearForm();
      Get.back();
      Get.snackbar("Success", "User created successfully", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveUpdatedUser(UserModel user) async {
    try {
      loading.value = true;
      UserModel updated = UserModel(
        id: user.id,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        password: passwordController.text.trim().isEmpty ? user.password : passwordController.text.trim(),
        role: selectedRole.value,
        status: isUserActive.value,
      );

      await _service.updateUser(updated);
      clearForm();
      Get.back();
      Get.snackbar("Success", "User updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      loading.value = false;
    }
  }

  Future<void> removeUser(String id) async {
    try {
      await _service.deleteUser(id);
      Get.snackbar("Success", "Deleted user successfully", backgroundColor: Colors.black87, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}