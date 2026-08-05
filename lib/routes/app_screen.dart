import 'package:get/get.dart';
import 'package:selling_project/binding/brand_binding.dart';
import 'package:selling_project/binding/customer_binding.dart';
import 'package:selling_project/binding/home_binding.dart';
import 'package:selling_project/binding/payment_binding.dart';
import 'package:selling_project/binding/product_binding.dart';
import 'package:selling_project/binding/purchase_binding.dart';
import 'package:selling_project/binding/sale_binding.dart';
import 'package:selling_project/binding/stock_adjustment_binding.dart';
import 'package:selling_project/binding/supplier_binding.dart';
import 'package:selling_project/binding/user_binding.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/screen/auth/login_screen.dart';
import 'package:selling_project/screen/brand/brand_screen.dart';
import 'package:selling_project/screen/customer/customer_screen.dart';
import 'package:selling_project/screen/home/home_screen.dart';
import 'package:selling_project/screen/payment/payment_screen.dart';
import 'package:selling_project/screen/product/product_screen.dart';
import 'package:selling_project/screen/purchase/purchase_screen.dart';
import 'package:selling_project/screen/sale/review_order_screen.dart';
import 'package:selling_project/screen/sale/sale_screen.dart';
import 'package:selling_project/screen/sale/sales_completion_screen.dart';
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
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoute.brand,
      page: () => BrandScreen(),
      binding: BrandBinding(),
    ),
    GetPage(
      name: AppRoute.customer,
      page: () => CustomerScreen(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: AppRoute.payment,
      page: () => PaymentScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: AppRoute.product,
      page: () => ProductScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoute.purchase,
      page: () => PurchaseScreen(),
      binding: PurchaseBinding(),
    ),
    GetPage(
      name: AppRoute.sale,
      page: () => SaleScreen(),
      binding: SaleBinding()
    ),
    GetPage(
      name: AppRoute.reviewOrderScreen,
      page: () => ReviewOrderScreen(),
      binding: SaleBinding(),
    ),
    GetPage(
      name: AppRoute.salesCompletionScreen,
      page: () => SalesCompletionScreen(),
      binding: SaleBinding(),
    ),
    GetPage(
      name: AppRoute.stockAdjustment,
      page: () => StockAdjustmentScreen(),
      binding: StockAdjustmentBinding(),
    ),
    GetPage(
      name: AppRoute.supplier,
      page: () => SupplierScreen(),
      binding: SupplierBinding(),
    ),
    GetPage(
      name: AppRoute.user,
      page: () => UserScreen(),
      binding: UserBinding(),
    ),
  ];
}
