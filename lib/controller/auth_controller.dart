import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/services/auth_service.dart';
import 'package:selling_project/services/storage_service.dart';
import 'package:selling_project/models/user_model.dart';

class AuthController extends GetxController {
  final AuthService service = AuthService();
  final StorageService storage = StorageService();

  RxBool loading = false.obs;
  Rxn<UserModel> currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final userData = storage.lastUserLoginRead;

    if (userData != null && userData is Map<String, dynamic>) {
      try {
        currentUser.value = UserModel.fromJson(userData);
      } catch (e) {
        print("Error parsing user data: $e");
      }
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      loading.value = true;

      await service.register(
        username: username,
        email: email,
        password: password,
      );

      Get.snackbar(
        "Success",
        "Register Success",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      loading.value = true;

      final user = await service.login(
        email: email,
        password: password,
      );

      if (user == null) {
        throw Exception("User not found");
      }

      currentUser.value = UserModel(
        id: user.uid,
        password: password,
        fullName: user.displayName ?? email.split('@').first,
        email: user.email ?? "",
        role: "admin",
      );

      await storage.lastUserLoginWrite(
        data: {
          "id": user.uid,
          "full_name": user.displayName ?? email.split('@').first,
          "email": user.email ?? "",
          "role": "admin",
        },
      );

      await storage.appStartUpWrite(
        route: AppRoute.home,
      );

      Get.offAllNamed(AppRoute.home);

      Get.snackbar(
        "Success",
        "Login Success",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }
}