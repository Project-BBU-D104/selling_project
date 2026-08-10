import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';
import 'package:selling_project/screen/stock_adjustment/widget/stock_adjustment_add_widget.dart';
import 'package:selling_project/screen/stock_adjustment/widget/stock_adjustment_card_widget.dart';

class StockAdjustmentScreen extends StatelessWidget {
  const StockAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StockAdjustmentController controller = Get.isRegistered<StockAdjustmentController>()
        ? Get.find<StockAdjustmentController>()
        : Get.put(StockAdjustmentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Adjustment History'),
      ),
      body: Obx(() {
        if (controller.stockAdjustments.isEmpty) {
          return const Center(
            child: Text('No stock adjustment data available'),
          );
        }

        return ListView.builder(
          itemCount: controller.stockAdjustments.length,
          itemBuilder: (context, index) {
            final adjustment = controller.stockAdjustments[index];
            return StockAdjustmentCardWidget(adjustment: adjustment);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            const Material(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: StockAdjustmentAddWidget(),
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}