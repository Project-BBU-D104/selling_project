import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/home_controller.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  final ctr = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final userName = ctr.user.value?.fullName ?? "Guest User";
              final userEmail = ctr.user.value?.email ?? "no-email@example.com";
              final userImage = ctr.user.value?.imageUrl ?? "";

              return UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: Color(0xFF003B6D),
                ),
                accountName: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                accountEmail: Text(
                  userEmail,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      userImage.isNotEmpty ? NetworkImage(userImage) : null,
                  child: userImage.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 35,
                          color: Color(0xFF003B6D),
                        )
                      : null,
                ),
              );
            }),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  _menu(
                    Icons.home_rounded,
                    "Home".tr,
                    () {
                      Get.back();
                      Get.until((route) => route.isFirst);
                    },
                  ),
                  _menu(
                    Icons.dashboard_rounded,
                    "Dashboard".tr,
                    () => ctr.gotoDashboardScreen(),
                  ),
                  _menu(
                    Icons.shopping_cart_rounded,
                    "Sales".tr,
                    () => ctr.gotoSaleListScreen(),
                  ),
                  _menu(
                    Icons.sell_rounded,
                    "Products".tr,
                    () => ctr.gotoProductScreen(),
                  ),
                  _menu(
                    Icons.inventory_2_rounded,
                    "Brand".tr,
                    () => ctr.gotoBrandScreen(),
                  ),
                  _menu(
                    Icons.people_alt_rounded,
                    "Customers".tr,
                    () => ctr.gotoCustomerScreen(),
                  ),
                  _menu(
                    Icons.local_shipping_rounded,
                    "Suppliers".tr,
                    () => ctr.gotoSupplierScreen(),
                  ),
                  _menu(
                    Icons.tune_rounded,
                    "Stock Adjustment".tr,
                    () => ctr.gotoStockAdjustmentScreen(),
                  ),
                  _menu(
                    Icons.payment_rounded,
                    "Payments".tr,
                    () => ctr.gotoPaymentScreen(),
                  ),
                  _menu(
                    Icons.person_rounded,
                    "User".tr,
                    () => ctr.gotoUserScreen(),
                  ),
                  _menu(
                    Icons.settings_rounded,
                    "Setting".tr,
                    () => ctr.gotoSettingScreen(),
                  ),
                ],
              ),
            ),
            const Divider(height: 2),
            _menu(
              Icons.logout_rounded,
              "Logout".tr,
              () => ctr.onLogout(),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.black87,
  }) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 12,
      leading: Icon(
        icon,
        color: color,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
