import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';

class SaleDetailScreen extends StatelessWidget {
  final String saleId;

  SaleDetailScreen({
    super.key,
    required this.saleId,
  });

  final SaleController ctr =
      Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Invoice $saleId",
        ),
      ),
      body: Obx(() {
 final customer =
      ctr.customer.value;

  if (customer == null) {
    return const Center(
      child: Text(
        "Customer not found",
      ),
    );
  }
        if (ctr.loadingItems.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (ctr.saleItems.isEmpty) {
          return const Center(
            child: Text(
              "No Items",
            ),
          );
        }

        return Column(
          children: [
             Card(
        child: ListTile(
          title: Text(
            customer.customerName,
          ),
          subtitle: Text(
            customer.phone,
          ),
        ),
      ),
      
            Expanded(
              child: ListView.builder(
                itemCount: ctr.saleItems.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  final item =
                      ctr.saleItems[index];
              
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(
                        item.productName,
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            item.categoryName,
                          ),
                          Text(
                            "Qty: ${item.quantity}",
                          ),
                          Text(
                            "Price: \$${item.unitPrice}",
                          ),
                        ],
                      ),
                      trailing: Text(
                        "\$${item.totalPrice}",
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}