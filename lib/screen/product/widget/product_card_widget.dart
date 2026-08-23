import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';
import 'package:selling_project/models/product_management/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String _getBrandName(String? brandId) {
    if (brandId == null || brandId.trim().isEmpty) {
      return 'Uncategorized';
    }

    // 💡 ប្រើ Get.put() បើមិនទាន់រៀបចំ ដើម្បីការពារ null controller
    final brandCtrl = Get.isRegistered<BrandController>()
        ? Get.find<BrandController>()
        : Get.put(BrandController());

    final brand = brandCtrl.brands.firstWhereOrNull(
      (b) => b.id == brandId,
    );

    if (brand != null && brand.name.isNotEmpty) {
      return brand.name;
    }

    return brandId;
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product.quantity == 0;
    final bool isLowStock = product.quantity <= 5 && !isOutOfStock;

    // 💡 Wrap ដោយ Obx ដើម្បីរង់ចាំ Reactive Data បង្ហាញឈ្មោះ Brand ដោយស្វ័យប្រវត្តិ
    return Obx(() {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade100,
                      child: product.image != null && product.image!.isNotEmpty
                          ? Image.network(
                              product.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.laptop_mac_outlined,
                                color: Colors.black87,
                                size: 32,
                              ),
                            )
                          : const Icon(
                              Icons.laptop_mac_outlined,
                              size: 32,
                              color: Colors.black87,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStockBadge(isOutOfStock, isLowStock),
                          ],
                        ),
                        Text(
                          "\$${product.salePrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Brand: ${_getBrandName(product.brandId)}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        if (product.description != null &&
                            product.description!.trim().isNotEmpty)
                          Text(
                            product.description!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${product.quantity} Units available",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onEdit,
                        icon: Icon(Icons.edit_outlined,
                            size: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline,
                            size: 16, color: Colors.redAccent),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}