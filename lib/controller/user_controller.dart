import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/services/user_services.dart';

class UserController extends GetxController {
  final UserService _service = UserService();
  final ImagePicker _picker = ImagePicker();

  RxList<UserModel> users = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
  RxBool loading = false.obs;

  var selectedImage = Rxn<File>();
  var existingImageUrl = Rxn<String>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  var selectedRole = 'Staff'.obs;
  var currentTab = 'All Users'.obs;
  var searchKeyword = ''.obs;

  final List<String> roleOptions = [
    'System Admin',
    'Chief Admin',
    'Logistics Manager',
    'Sales Associate',
    'Support Tech',
    'Staff',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
    existingImageUrl.value = null;
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
      temp = temp.where((u) => u.role.contains('Admin')).toList();
    } else if (currentTab.value == 'Managers') {
      temp = temp.where((u) => u.role.contains('Manager')).toList();
    } else if (currentTab.value == 'Staff') {
      temp = temp.where((u) => u.role == 'Staff' || u.role.contains('Associate') || u.role.contains('Tech')).toList();
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
    selectedRole.value = roleOptions.contains(user.role) ? user.role : 'Staff';
    existingImageUrl.value = user.imageUrl;
    selectedImage.value = null;
  }

  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    selectedRole.value = 'Staff';
    selectedImage.value = null;
    existingImageUrl.value = null;
  }

  Future<void> createUser() async {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Full name is required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email is required for Firebase Authentication", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      loading.value = true;
      String? uploadedUrl;

      if (selectedImage.value != null) {
        uploadedUrl = await _service.uploadImage(selectedImage.value!);
      }

      String passwordToUse = passwordController.text.trim().isEmpty ? '123456' : passwordController.text.trim();

      UserModel newUser = UserModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        password: passwordToUse,
        role: selectedRole.value,
        status: true,
        imageUrl: uploadedUrl,
      );
      await _service.addUser(newUser, passwordToUse);

      clearForm();
      Get.back();
      Get.snackbar("Success", "User created successfully", backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveUpdatedUser(UserModel user) async {
    try {
      loading.value = true;
      String? imageUrl = existingImageUrl.value;

      if (selectedImage.value != null) {
        imageUrl = await _service.uploadImage(selectedImage.value!);
      }

      UserModel updated = UserModel(
        id: user.id,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        password: passwordController.text.trim().isEmpty ? user.password : passwordController.text.trim(),
        role: selectedRole.value,
        status: user.status,
        imageUrl: imageUrl,
        createdAt: user.createdAt,
      );

      await _service.updateUser(updated);
      clearForm();
      Get.back();
      Get.snackbar("Success", "User updated successfully", backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    } finally {
      loading.value = false;
    }
  }

  Future<void> removeUser(String id) async {
    try {
      loading.value = true;
      await _service.deleteUser(id);
      Get.snackbar("Success", "User deleted successfully", backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    } finally {
      loading.value = false;
    }
  }
}