import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'sale_detail_screen.dart';

class SaleListScreen extends StatelessWidget {
  SaleListScreen({super.key});

  final SaleController ctr = Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales History", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF004C87),
        foregroundColor: Colors.white,
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
                    label: const Text("Test Save Sale"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black87),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ctr.gotoSaleScreen,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("POS Screen"),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004C87), foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Obx(() {
              if (ctr.sales.isEmpty) {
                return const Center(child: Text("No Sales Recorded"));
              }

              return ListView.builder(
                itemCount: ctr.sales.length,
                itemBuilder: (context, index) {
                  final sale = ctr.sales[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: sale.paymentStatus == "paid" ? Colors.green.shade50 : Colors.orange.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          color: sale.paymentStatus == "paid" ? Colors.green : Colors.orange,
                        ),
                      ),
                      title: Text(
                        "Invoice: ${sale.invoiceNo}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("Customer ID: ${sale.customerId ?? 'N/A'}", style: TextStyle(color: Colors.grey.shade600)),
                          Text("Date: ${sale.saleDate.toString().substring(0, 16)}", style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$${sale.totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF004C87)),
                          ),
                          const SizedBox(height: 4),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                      onTap: () async {
                        ctr.loadingItems.value = true;
                        if (sale.customerId != null) {
                          await ctr.loadCustomer(sale.customerId!);
                        } else {
                          ctr.customer.value = null;
                        }
                        ctr.loadSaleItems(sale.id!);
                        Get.to(() => SaleDetailScreen(saleId: sale.id!, invoiceNo: sale.invoiceNo, totalAmount: sale.totalAmount, subtotal: sale.subtotal));
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