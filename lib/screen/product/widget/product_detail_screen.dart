import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/controller/supplier_controller.dart';
import 'package:selling_project/models/product_management/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  String _getCategoryName(String? categoryId) {
    if (categoryId == null || categoryId.trim().isEmpty) {
      return 'N/A';
    }
    if (Get.isRegistered<CategoryController>()) {
      final categoryCtrl = Get.find<CategoryController>();
      final category = categoryCtrl.category.firstWhereOrNull(
        (cat) => cat.id == categoryId,
      );
      if (category != null && category.name.isNotEmpty) {
        return category.name;
      }
    }
    return categoryId;
  }
  String _getSupplierName(String? supplierId) {
    if (supplierId == null || supplierId.trim().isEmpty) {
      return 'N/A';
    }
    if (Get.isRegistered<SupplierController>()) {
      final supplierCtrl = Get.find<SupplierController>();
      final supplier = supplierCtrl.suppliers.firstWhereOrNull(
        (sup) => sup.id == supplierId,
      );
      if (supplier != null && supplier.name.isNotEmpty) {
        return supplier.name;
      }
    }
    return supplierId;
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product.quantity == 0;
    final bool isLowStock = product.quantity <= 5 && !isOutOfStock;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Product Detail',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 280,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: product.image != null && product.image!.isNotEmpty
                  ? Image.network(
                      product.image!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.laptop_mac_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.laptop_mac_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      _buildStockBadge(isOutOfStock, isLowStock),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "\$${product.salePrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (product.costPrice != null)
                        Text(
                          "Cost Price: \$${product.costPrice!.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.category_outlined,
                          title: 'Category',
                          value: _getCategoryName(product.categoryId),
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          icon: Icons.inventory_2_outlined,
                          title: 'Available Quantity',
                          value: '${product.quantity} Units',
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          icon: Icons.local_shipping_outlined,
                          title: 'Supplier',
                          value: _getSupplierName(product.supplierId),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      (product.description != null && product.description!.trim().isNotEmpty)
                          ? product.description!
                          : 'No description provided.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStockBadge(bool isOutOfStock, bool isLowStock) {
    final String label = isOutOfStock
        ? 'Out of Stock'
        : isLowStock
            ? 'Low Stock'
            : 'In Stock';

    final Color bgColor = isOutOfStock
        ? Colors.red.shade50
        : isLowStock
            ? Colors.orange.shade50
            : const Color(0xFFDCFCE7);

    final Color textColor = isOutOfStock
        ? Colors.red.shade700
        : isLowStock
            ? Colors.orange.shade800
            : const Color(0xFF166534);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}