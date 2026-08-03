import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/screen/home/widget/drawer_widget.dart';
import 'package:selling_project/screen/sale/widget/sale_product_card_widget.dart';

class SaleScreen extends StatelessWidget {
  SaleScreen({super.key});

  // 1. ប្រើ lazy / put ដើមបីការពារ Null Controller
  final SaleController ctr = Get.put(SaleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Sale",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          Column(
            children: [
              // 🔍 SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: ctr.searchController,
                  onChanged: (_) => ctr.filterProducts(),
                  decoration: InputDecoration(
                    hintText: "Search Product...",
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),

              // 🏷️ CATEGORY FILTER CHIPS
              SizedBox(
                height: 40,
                child: Obx(() {
                  final categories = ctr.categoryCtr.category;
                  final selectedId = ctr.selectedCategoryId.value;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length + 1, // +1 for "All"
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected = selectedId == 'All';
                        return ChoiceChip(
                          label: const Text('All'),
                          selected: isSelected,
                          selectedColor: const Color(0xFF007AE5),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          onSelected: (_) => ctr.selectCategory('All'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }

                      final cat = categories[index - 1];
                      final isSelected = selectedId == cat.id;

                      return ChoiceChip(
                        label: Text(cat.name ?? ''),
                        selected: isSelected,
                        selectedColor: const Color(0xFF007AE5),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        onSelected: (_) => ctr.selectCategory(cat.id ?? ''),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 8),

              // 🛍️ PRODUCT GRID
              Expanded(
                child: Obx(() {
                  if (ctr.filteredProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Products Found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 100,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: ctr.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = ctr.filteredProducts[index];
                      return SaleProductCardWidget(
                        product: product,
                        onAdd: () => ctr.addToCart(product),
                      );
                    },
                  );
                }),
              ),
            ],
          ),

          // 🛒 CURRENT ORDER BOTTOM BAR
          Obx(() {
            if (ctr.cartItems.isEmpty) return const SizedBox.shrink();

            final int itemCount = ctr.totalCartCount;
            final double totalAmount = ctr.totalCartAmount;

            return Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(35),
                  onTap: () {
                    final double calculatedTax = totalAmount * 0.0825;

                    SaleModel pendingSale = SaleModel(
                      userId: "usr_123",
                      customerId: "88291",
                      invoiceNo: "INV-${DateTime.now().millisecondsSinceEpoch}",
                      items: List.from(ctr.cartItems),
                      subtotal: totalAmount,
                      tax: calculatedTax,
                      discount: 0.0,
                      totalAmount: totalAmount + calculatedTax,
                      saleDate: DateTime.now(),
                      paymentStatus: "Pending",
                    );
                    Get.toNamed(
                      AppRoute.reviewOrderScreen,
                      arguments: pendingSale,
                      preventDuplicates: true,
                    );
                  },
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A86B),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00A86B).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "$itemCount",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Current Order",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              "$itemCount Items",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          "\$${totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF00A86B),
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}