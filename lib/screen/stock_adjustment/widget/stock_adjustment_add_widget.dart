import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';
import 'package:selling_project/models/product_management/product_model.dart';

class StockAdjustmentAddWidget extends StatelessWidget {
  const StockAdjustmentAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockAdjustmentController>();
    final productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update (Stock Adjustment)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final selectedId = controller.selectedProduct.value?.id;
              final isValidSelection = productController.product
                  .any((item) => item.id == selectedId);

              return DropdownButtonFormField<String>(
                initialValue: isValidSelection ? selectedId : null,
                hint: const Text('Select Product'),
                items: productController.product.map((ProductModel product) {
                  return DropdownMenuItem<String>(
                    value: product.id,
                    child: Text(
                      '${product.productName} (Current Stock: ${product.quantity})',
                    ),
                  );
                }).toList(),
                onChanged: (String? newId) {
                  if (newId != null) {
                    final selected = productController.product.firstWhere(
                      (item) => item.id == newId,
                    );
                    controller.selectedProduct.value = selected;
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }),

            const SizedBox(height: 12),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Add (+)'),
                        value: 'ADD',
                        groupValue: controller.adjustmentType.value,
                        onChanged: (val) =>
                            controller.adjustmentType.value = val!,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Remove (-)'),
                        value: 'SUBTRACT',
                        groupValue: controller.adjustmentType.value,
                        onChanged: (val) =>
                            controller.adjustmentType.value = val!,
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 8),
            TextField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Reason (ex: Damaged, Expired, Lost, Broken, etc.)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.addAdjustment(),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}