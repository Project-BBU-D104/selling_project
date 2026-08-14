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
            // Header: User Profile
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

            // Menu Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  // --- GROUP 1: OVERVIEW ---
                  _sectionTitle("OVERVIEW"),
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

                  const Divider(height: 16, thickness: 0.8),

                  // --- GROUP 2: TRANSACTIONS ---
                  _sectionTitle("DAILY OPERATIONS"),
                  _menu(
                    Icons.shopping_cart_rounded,
                    "Sales".tr,
                    () => ctr.gotoSaleListScreen(),
                  ),
                  _menu(
                    Icons.payment_rounded,
                    "Payments".tr,
                    () => ctr.gotoPaymentScreen(),
                  ),

                  const Divider(height: 16, thickness: 0.8),

                  // --- GROUP 3: INVENTORY ---
                  _sectionTitle("INVENTORY"),
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
                    Icons.tune_rounded,
                    "Stock Adjustment".tr,
                    () => ctr.gotoStockAdjustmentScreen(),
                  ),

                  const Divider(height: 16, thickness: 0.8),

                  // --- GROUP 4: PEOPLE & SYSTEM ---
                  _sectionTitle("PEOPLE & MANAGEMENT"),
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
                    Icons.person_rounded,
                    "User".tr,
                    () => ctr.gotoUserScreen(),
                  ),

                  const Divider(height: 16, thickness: 0.8),

                  // --- GROUP 5: REPORTS & SETTINGS ---
                  _sectionTitle("SYSTEM & REPORTS"),
                  _menu(
                    Icons.bar_chart_rounded,
                    "Report".tr,
                    () => ctr.gotoReportScreen(),
                  ),
                  _menu(
                    Icons.settings_rounded,
                    "Setting".tr,
                    () => ctr.gotoSettingScreen(),
                  ),
                ],
              ),
            ),

            // Logout Action at bottom
            const Divider(height: 1, thickness: 1),
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

  // Header សម្រាប់បែងចែកប្រភេទ Menu នីមួយៗ
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 6, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Menu Item Reusable Widget
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