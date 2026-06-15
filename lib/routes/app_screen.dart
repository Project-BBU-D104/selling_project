import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/screen/auth/login_screen.dart';
import 'package:selling_project/screen/brand/brand_screen.dart';
import 'package:selling_project/screen/category/category_screen.dart';
import 'package:selling_project/screen/customer/customer_screen.dart';
import 'package:selling_project/screen/home/home_screen.dart';
import 'package:selling_project/screen/payment/payment_screen.dart';
import 'package:selling_project/screen/product/product_screen.dart';
import 'package:selling_project/screen/purchase/purchase_screen.dart';
import 'package:selling_project/screen/sale/sale_screen.dart';
import 'package:selling_project/screen/splash_screen.dart';
import 'package:selling_project/screen/stock_adjustment/stock_adjustment_screen.dart';
import 'package:selling_project/screen/supplier/supplier_screen.dart';
import 'package:selling_project/screen/user/user_screen.dart';

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
    GetPage(
      name: AppRoute.brand,
      page: () => BrandScreen(),
    ),
    GetPage(
      name: AppRoute.category,
      page: () => CategoryScreen(),
    ),
    GetPage(
      name: AppRoute.customer,
      page: () => CustomerScreen(),
    ),
    GetPage(
      name: AppRoute.payment,
      page: () => PaymentScreen(),
    ),
    GetPage(
      name: AppRoute.product,
      page: () => ProductScreen(),
    ),
    GetPage(
      name: AppRoute.purchase,
      page: () => PurchaseScreen(),
    ),
    GetPage(
      name: AppRoute.sale,
      page: () => SaleScreen(),
    ),
    GetPage(
      name: AppRoute.stockAdjustment,
      page: () => StockAdjustmentScreen(),
    ),
    GetPage(
      name: AppRoute.supplier,
      page: () => SupplierScreen(),
    ),
    GetPage(
      name: AppRoute.user,
      page: () => UserScreen(),
    ),
  ];
}
