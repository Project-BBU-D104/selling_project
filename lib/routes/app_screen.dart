import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/screen/auth/login_screen.dart';
import 'package:selling_project/screen/home/home_screen.dart';
import 'package:selling_project/screen/splash_screen.dart';

class AppScreen {
  static final pages = [
    GetPage(
      name: AppRoute.splash,
      page: () => SplashScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoute.login,
      page: () => LoginScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoute.home,
      page: () => HomeScreen(),
      // binding: SplashBinding(),
    ),
  ];
}
