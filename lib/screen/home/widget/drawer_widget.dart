import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/constants/constant.dart';
import 'package:selling_project/controller/home_controller.dart';

class DrawerWidget extends StatelessWidget {
    DrawerWidget({super.key});
final ctr = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                "Selling Project",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Sale"),
              onTap: () {
                ctr.gotoSaleScreen();
              },
            ),

            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Products"),
              onTap: () {
                ctr.gotoProductScreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Brand"),
              onTap: () {
                ctr.gotoBrandScreen();
              },
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Customers"),
              onTap: () {
                ctr.gotoCustomerScreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Suppliers"),
              onTap: () {
                ctr.gotoSupplierScreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Payment"),
              onTap: () {
                ctr.gotoPaymentScreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Purchase"),
              onTap: () {
                ctr.gotoPurchaseScreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Stock Adjustment"),
              onTap: () {
                ctr.gotoStockAdjustmentScreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("User"),
              onTap: () {
                ctr.gotoUserScreen();
              },
            ),

            const Divider(),

            ListTile(
              leading:  Icon(Icons.logout,
                color: dangerColor,
              ),
              title: Text("Logout"
                ,style: TextStyle(
                  color: dangerColor,
                ),
              ),
              onTap: () {
                ctr.onLogout();
                // logout
              },
            ),
          ],
        ),
      );
  }
}