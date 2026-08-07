import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/services/auth_service.dart';

class SettingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userName = "Loading...".obs;
  var userEmail = "Loading...".obs;
  var userRole = "Loading...".obs;
  var userProfileImage = "".obs; 

  var isDarkMode = false.obs;
  var pushNotifications = true.obs;
  var emailAlerts = true.obs;
  var selectedLanguage = 'English (US)'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        
        if (userDoc.exists) {
          UserModel userModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

          userName.value = userModel.fullName.isNotEmpty ? userModel.fullName : 'User';
          userEmail.value = userModel.email ?? currentUser.email ?? 'No Email';
          userRole.value = userModel.role;
          userProfileImage.value = userModel.imageUrl ?? '';
          
          print("Loaded Image URL: ${userProfileImage.value}");
        } else {
          userName.value = currentUser.displayName ?? 'User';
          userEmail.value = currentUser.email ?? 'No Email';
          userRole.value = 'Staff';
          userProfileImage.value = '';
        }
      }
    } catch (e) {
      userName.value = "Error loading user";
      print("Error fetching user data: $e");
    }
  }

  void toggleDarkMode(bool value) => isDarkMode.value = value;
  void togglePushNotifications(bool value) => pushNotifications.value = value;
  void toggleEmailAlerts(bool value) => emailAlerts.value = value;

  void changeLanguage(String langCode, String langName) {
    selectedLanguage.value = langName;
    if (langCode == 'km') {
      Get.updateLocale(const Locale('km', 'KH'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
    Get.back();
  }

  Future<void> signOut() async {
    try {
      await AuthService.instance.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Failed to sign out: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}