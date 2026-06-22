import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/home_controller.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  final ctr = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF003B6D),
            ),
            accountName: const Text(
              "HardwarePro Enterprise",
            ),
            accountEmail: const Text(
              "Inventory Management System",
            ),
            currentAccountPicture: const CircleAvatar(
              child: Icon(
                Icons.business,
                size: 40,
              ),
            ),
          ),
          _menu(
            Icons.home,
            "Home",
            () => Get.back(),
          ),
          _menu(
            Icons.shopping_cart,
            "Sales",
            () => ctr.gotoSaleListScreen(),
          ),
          _menu(
            Icons.sell,
            "Products",
            () => ctr.gotoProductScreen(),
          ),
          _menu(
            Icons.category,
            "Category",
            () => ctr.gotoCategoryScreen(),
          ),
          _menu(
            Icons.inventory,
            "Brand",
            () => ctr.gotoBrandScreen(),
          ),
          _menu(
            Icons.people,
            "Customers",
            () => ctr.gotoCustomerScreen(),
          ),
          _menu(
            Icons.local_shipping,
            "Suppliers",
            () => ctr.gotoSupplierScreen(),
          ),
          const Spacer(),
          const Divider(),
          _menu(
            Icons.logout,
            "Logout",
            () => ctr.onLogout(),
            color: Colors.red,
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
