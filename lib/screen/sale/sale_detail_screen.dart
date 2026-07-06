import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'package:selling_project/screen/sale/widget/customer_header_widget.dart';
import 'package:selling_project/screen/sale/widget/sale_item_tile_widget.dart';

class SaleDetailScreen extends StatelessWidget {
  final String saleId;
  SaleDetailScreen({super.key, required this.saleId});

  final SaleController ctr = Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice #$saleId"),
      ),
      body: Obx(() {
        if (ctr.loadingCustomer.value || ctr.loadingItems.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final customer = ctr.customer.value;

        return Column(
          children: [
            customer != null
                ? CustomerHeaderWidget(customer: customer)
                : Card(
                    margin: const EdgeInsets.all(12),
                    color: Colors.red[50],
                    child: const ListTile(
                      leading: Icon(Icons.warning, color: Colors.red),
                      title: Text("មិនមានព័ត៌មានអតិថិជនឡើយ (Walk-in ឬទិន្នន័យត្រូវបានលុប)"),
                    ),
                  ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Purchased Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ctr.saleItems.isEmpty
                  ? const Center(child: Text("No items tied to this sale transaction"))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: ctr.saleItems.length,
                      itemBuilder: (context, index) {
                        return SaleItemTileWidget(item: ctr.saleItems[index]);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}