import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';

class StockAdjustmentAddWidget extends GetView<StockAdjustmentController> {
  const StockAdjustmentAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    controller.clearForm();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New Stock Adjustment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Adjustment Name / Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Obx(() => DropdownButtonFormField<String>(
                  initialValue: controller.adjustmentType.value,
                  decoration: const InputDecoration(labelText: 'Adjustment Type', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Decrease', child: Text('Decrease (Damaged, Lost, Expired)')),
                    DropdownMenuItem(value: 'Increase', child: Text('Increase (Found Extra)')),
                  ],
                  onChanged: (val) => controller.adjustmentType.value = val!,
                )),
            const SizedBox(height: 12),
            TextField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.reasonController,
              decoration: const InputDecoration(labelText: 'Reason (e.g. Broken item)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: () => controller.addStockAdjustment(),
                child: const Text("Save Adjustment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}