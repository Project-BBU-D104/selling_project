import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/home_controller.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  final ctr = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF003B6D),
            ),
            accountName: Text(
              "Computer Shop",
            ),
            accountEmail: Text(
              "Inventory Management",
            ),
            currentAccountPicture: CircleAvatar(
              child: Icon(
                Icons.business,
                size: 40,
              ),
            ),
          ),
          _menu(
            Icons.home,
            "Home".tr,
            () {
              Get.back();
              Get.until((route) => route.isFirst);
            },
          ),

          _menu(
            Icons.dashboard,
            "Dashboard".tr,
            () => ctr.gotoDashboardScreen(),
          ),
          _menu(
            Icons.shopping_cart,
            "Sales".tr,
            () => ctr.gotoSaleListScreen(),
          ),
          _menu(
            Icons.sell,
            "Products".tr,
            () => ctr.gotoProductScreen(),
          ),
          _menu(
            Icons.inventory,
            "Brand".tr,
            () => ctr.gotoBrandScreen(),
          ),
          _menu(
            Icons.people,
            "Customers".tr,
            () => ctr.gotoCustomerScreen(),
          ),
          _menu(
            Icons.local_shipping,
            "Suppliers".tr,
            () => ctr.gotoSupplierScreen(),
          ),
          _menu(
            Icons.person,
            "User".tr,
            () => ctr.gotoUserScreen(),
          ),

          // _menu(
          //   Icons.payment,
          //   "Payments",
          //   () => ctr.gotoPaymentScreen()
          // ),
          // _menu(
          //   Icons.local_shipping_outlined,
          //   "Purchase",
          //   () => ctr.gotoPurchaseScreen()
          // ),
          const Spacer(),
          const Divider(),
          // _menu(
          //   Icons.logout,
          //   "Logout".tr,
          //   () => ctr.onLogout(),
          //   color: Colors.red,
          // ),
          _menu(
            Icons.settings,
            "Setting".tr,
            () => ctr.gotoSettingScreen(),
          ),
        ],
      ),
    );
  }

  Widget _menu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}
