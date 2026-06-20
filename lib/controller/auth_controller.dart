import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/services/auth_service.dart';


class AuthController
    extends GetxController {
  final AuthService service =
      AuthService();

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
    required String username,
    required String password,
  }) async {
    try {
      loading.value = true;

      print("Username: $username");

      await service.login(
        username: username,
        password: password,
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