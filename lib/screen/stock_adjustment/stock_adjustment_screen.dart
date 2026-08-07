import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/screen/stock_adjustment/widget/stock_adjustment_card_widget.dart';
import 'package:selling_project/screen/stock_adjustment/widget/stock_adjustment_add_widget.dart';

class StockAdjustmentScreen extends GetView<StockAdjustmentController> {
  const StockAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Adjustments"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () => Get.bottomSheet(
              const StockAdjustmentAddWidget(),
              isScrollControlled: true,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<StockAdjustmentModel>>(
        stream: controller.stockAdjustmentsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No stock adjustments recorded yet.", style: TextStyle(color: Colors.grey)),
            );
          }

          final adjustments = snapshot.data!;

          return ListView.builder(
            itemCount: adjustments.length,
            itemBuilder: (context, index) {
              final item = adjustments[index];
              return StockAdjustmentCardWidget(
                adjustment: item,
                onDelete: () {
                  Get.defaultDialog(
                    title: "Delete Adjustment",
                    middleText: "Are you sure you want to delete this record?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      controller.deleteStockAdjustment(item.id!);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}