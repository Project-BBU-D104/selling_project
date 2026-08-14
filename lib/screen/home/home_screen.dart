import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/home_controller.dart';
import 'package:selling_project/screen/home/widget/drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ctr = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text("Computer Shop"),
        backgroundColor: const Color(0xFF003B6D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF003B6D),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Inventory Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _card(
                    Icons.shopping_cart,
                    "Sales".tr,
                    () => ctr.gotoSaleListScreen(),
                  ),
                  _card(
                    Icons.sell,
                    "Products".tr,
                    () => ctr.gotoProductScreen(),
                  ),
                  _card(
                    Icons.inventory,
                    "Brand".tr,
                    () => ctr.gotoBrandScreen(),
                  ),
                  _card(
                    Icons.local_shipping_outlined,
                    "Purchase".tr,
                    () => ctr.gotoPurchaseScreen(),
                  ),
                  // _card(
                  //   Icons.payment,
                  //   "Payment".tr,
                  //   () => ctr.gotoPaymentScreen(),
                  // ),
                  // _card(
                  //   Icons.tune,
                  //   "Stock Adjustment".tr,
                  //   () => ctr.gotoStockAdjustmentScreen(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
              color: const Color(0xFF003B6D),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
