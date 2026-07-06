import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'package:selling_project/screen/sale/widget/sale_card_widget.dart';
import 'sale_detail_screen.dart';

class SaleListScreen extends StatelessWidget {
  SaleListScreen({super.key});

  final SaleController ctr = Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales History"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ctr.createSale,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Test Sale"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ctr.gotoSaleScreen,
                    icon: const Icon(Icons.add),
                    label: const Text("New Sale Screen"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctr.sales.isEmpty) {
                return const Center(child: Text("No Sales Records Found"));
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ctr.sales.length,
                itemBuilder: (context, index) {
                  final sale = ctr.sales[index];

                  return SaleCardWidget(
                    sale: sale,
                    onTap: () async {
                      if (sale.customerId != null) {
                        await ctr.loadCustomer(sale.customerId!);
                      }
                      ctr.loadSaleItems(sale.id!);
                      Get.to(() => SaleDetailScreen(saleId: sale.id!));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}