import 'package:flutter/material.dart';
import 'package:selling_project/models/product_management/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product.quantity == 0;
    final bool isLowStock = product.quantity <= 5 && !isOutOfStock;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // 👈 កែមកប្រើ CrossAxisAlignment
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 75,
                  height: 75,
                  color: Colors.grey.shade100,
                  child: product.image != null && product.image!.isNotEmpty
                      ? Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
                          Icons.inventory_2_outlined,
                          size: 32,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stock Badge Status
                    _buildStockBadge(isOutOfStock, isLowStock),
                    const SizedBox(height: 4),
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Cat: ${product.categoryId ?? 'N/A'} • Brand: ${product.brandId ?? 'N/A'}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (product.description != null && product.description!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          product.description!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                "\$${product.salePrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${product.quantity} Units available",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                  ),
                ],
              )
            ],
          )
        ],
      ),
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
            : Colors.green.shade50;

    final Color textColor = isOutOfStock
        ? Colors.red.shade700
        : isLowStock
            ? Colors.orange.shade800
            : Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}