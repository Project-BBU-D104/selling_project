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

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                const Text(
                  'New Adjustment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2C59),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Product Section Label
            Row(
              children: const [
                Icon(Icons.inventory_2_outlined, size: 18, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  'Product',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Searchable Product Dropdown / Selected Product
            Obx(() {
              final selected = controller.selectedProduct.value;

              if (selected != null) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF004C87)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF004C87)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected.productName ?? 'Unnamed Product',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'In Stock: ${selected.quantity ?? 0}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12, 
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: controller.clearSelectedProduct,
                      ),
                    ],
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  return RawAutocomplete<ProductModel>(
                    displayStringForOption: (ProductModel option) =>
                        option.productName ?? '',
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return controller.filterProducts(
                        textEditingValue.text,
                        productController.product,
                      );
                    },
                    onSelected: controller.selectProduct,
                    fieldViewBuilder: (
                      context,
                      textEditingController,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: 'Search product by name or SKU...',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: constraints.maxWidth,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final ProductModel option =
                                    options.elementAt(index);
                                return ListTile(
                                  title: Text(
                                    option.productName ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    'Stock: ${option.quantity ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 20),

            // Adjustment Type
            const Text(
              'Adjustment Type',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() {
                final isAdd = controller.adjustmentType.value == 'ADD';
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.adjustmentType.value = 'ADD',
                        child: _typeTab(
                          title: 'Increase',
                          icon: Icons.add_circle_outline,
                          isSelected: isAdd,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            controller.adjustmentType.value = 'SUBTRACT',
                        child: _typeTab(
                          title: 'Decrease',
                          icon: Icons.remove_circle_outline,
                          isSelected: !isAdd,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),

            // Quantity
            Row(
              children: const [
                Text(
                  '# ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _quantityBtn(
                  icon: Icons.remove,
                  onTap: controller.decreaseQuantity,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller.quantityController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _quantityBtn(
                  icon: Icons.add,
                  onTap: controller.increaseQuantity,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reason
            const Text(
              'Reason',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              hint: const Text('Select a reason', style: TextStyle(fontSize: 13)),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Restock', child: Text('Restock')),
                DropdownMenuItem(value: 'Damaged', child: Text('Damaged')),
                DropdownMenuItem(value: 'Return', child: Text('Return')),
                DropdownMenuItem(
                  value: 'Wrong Inventory',
                  child: Text('Wrong Inventory'),
                ),
                DropdownMenuItem(value: 'Expired', child: Text('Expired')),
              ],
              onChanged: (val) {
                if (val != null) controller.reasonController.text = val;
              },
            ),
            const SizedBox(height: 20),

            // Remarks
            const Text(
              'Remarks',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.remarksController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter any additional details or notes here...',
                hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004C87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.addAdjustment(),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Adjustment',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeTab({
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isSelected
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _quantityBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}