import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/services/auth_service.dart';
import 'package:selling_project/services/storage_service.dart';

class AuthController extends GetxController {
  final AuthService service = AuthService();

  final StorageService storage = StorageService();

  RxBool loading = false.obs;

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

      await storage.lastUserLoginWrite(
        data: {
          "uid": user.uid,
          "email": user.email ?? "",
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
