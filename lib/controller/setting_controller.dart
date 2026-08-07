import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selling_project/models/user_model.dart';
import 'package:selling_project/services/auth_service.dart';

class SettingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _box = GetStorage();

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
    
    isDarkMode.value = _box.read('isDarkMode') ?? false;
    pushNotifications.value = _box.read('pushNotifications') ?? true;
    emailAlerts.value = _box.read('emailAlerts') ?? true;
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _box.write('isDarkMode', value);
    
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  // 🟢 មុខងារគ្រប់គ្រង Push Notifications (FCM)
  Future<void> togglePushNotifications(bool value) async {
    pushNotifications.value = value;
    _box.write('pushNotifications', value);

    try {
      if (value) {
        // បើកការទទួលសារ៖ ស្នើសុំសិទ្ធិ (បើទូរស័ព្ទខ្លះត្រូវការ) និង Subscribe Topic ឬបើក FCM Token ឡើងវិញ
        NotificationSettings settings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          // ប្រសិនបើអ្នកប្រើ Topic-based messaging
          await _messaging.subscribeToTopic('all_users');
          Get.snackbar("Success", "Push notifications enabled", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
        }
      } else {
        await _messaging.unsubscribeFromTopic('all_users');
        
        User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          await _firestore.collection('users').doc(currentUser.uid).update({
            'fcmToken': null,
          });
        }
        Get.snackbar("Success", "Push notifications disabled", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      }
    } catch (e) {
      print("Error toggling push notifications: $e");
      Get.snackbar("Error", "Failed to update notification settings", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> toggleEmailAlerts(bool value) async {
    emailAlerts.value = value;
    _box.write('emailAlerts', value);

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'emailAlerts': value,
        });

        Get.snackbar(
          "Updated", 
          value ? "Email alerts enabled" : "Email alerts disabled", 
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print("Error updating email alerts in Firestore: $e");
      Get.snackbar("Error", "Failed to update email preferences", snackPosition: SnackPosition.BOTTOM);
    }
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
          
          if (userDoc.data().toString().contains('emailAlerts')) {
            emailAlerts.value = userDoc['emailAlerts'] ?? true;
          }
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