import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
    HomeScreen({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: Drawer(
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
              title: const Text("POS"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Products"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Customers"),
              onTap: () {
                controller.gotoCustomerScreen();
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                // logout
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("Home Screen"),
      ),
    );
  }
}