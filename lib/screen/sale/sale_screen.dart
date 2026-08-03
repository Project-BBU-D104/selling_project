import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/screen/sale/widget/sale_product_card_widget.dart';

class SaleScreen extends GetView<SaleController> {
  const SaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Sale",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: controller.searchController,
              onChanged: (val) => controller.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: "Search Product...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Obx(() {
            final categories = controller.categoryCtr.category;
            return SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isSelected = controller.selectedCategoryId.value == 'All';
                    return GestureDetector(
                      onTap: () => controller.selectCategory('All'),
                      child: _buildCategoryChip("All", isSelected),
                    );
                  }
                  final category = categories[index - 1];
                  final isSelected = controller.selectedCategoryId.value == (category.id ?? '');
                  return GestureDetector(
                    onTap: () => controller.selectCategory(category.id ?? ''),
                    child: _buildCategoryChip(category.name ?? '', isSelected),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) { 
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.productList.isEmpty) {
                return const Center(child: Text("No products found"));
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.productList.length,
                itemBuilder: (context, index) {
                  final product = controller.productList[index];
                  final cartQty = controller.getCartItemQty(product.id ?? '');
                  
                  return SaleProductCardWidget(
                    product: product,
                    cartQuantity: cartQty,
                    onAdd: () => controller.addToCart(product),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (controller.totalCartQuantity == 0) return const SizedBox.shrink();
        return InkWell(
          onTap: () {
            Get.toNamed(AppRoute.saleDetailScreen);
          },
          child: Container(
            height: 55,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF00A3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quantity  ${controller.totalCartQuantity}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Subtotal  \$${controller.subtotalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00A3FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}