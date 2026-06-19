import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'sale_detail_screen.dart';

class SaleListScreen extends StatelessWidget {
  SaleListScreen({super.key});

  final SaleController ctr =
      Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales"),
      ),
      body: Column(
        children: [

          ElevatedButton(onPressed: ctr.createSale, child: Text("Save Sale")),
          ElevatedButton(onPressed: ctr.gotoSaleScreen, child: Text("Add New Sale")),
          
          Expanded(
            child: Obx(() {
              if (ctr.sales.isEmpty) {
                return const Center(
                  child: Text(
                    "No Sales",
                  ),
                );
              }
            
              return ListView.builder(
                itemCount: ctr.sales.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  final sale =
                      ctr.sales[index];
            
                  return Card(
                    child: ListTile(
                      title: Column(
                        children: [
                          Text(sale.customerId.toString()),
                          Text(
                            sale.invoiceNo,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "Total: \$${sale.totalAmount}",
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward_ios),
                      onTap: () async  {
            await ctr.loadCustomer(
    sale.customerId!,
  );
                        ctr.loadSaleItems(
                          sale.id!,
                        );
            
                        Get.to(
                          () => SaleDetailScreen(
                            saleId: sale.id!,
                          ),
                        );
                      },
                    ),
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