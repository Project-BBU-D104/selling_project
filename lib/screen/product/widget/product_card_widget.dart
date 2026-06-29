import 'package:flutter/material.dart';
import '../../../../models/product_management/product_model.dart';
import 'product_tokens.dart';

/// Colored badge that switches between IN STOCK / LOW STOCK / OUT OF STOCK.
class StockStatusBadge extends StatelessWidget {
  final int quantity;

  const StockStatusBadge({Key? key, required this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color fg;
    late Color bg;

    if (quantity <= 0) {
      label = 'OUT OF STOCK';
      fg = ProductTokens.red;
      bg = const Color(0xFFFBE6E6);
    } else if (quantity <= 5) {
      label = 'LOW STOCK';
      fg = ProductTokens.orange;
      bg = ProductTokens.orangeBg;
    } else {
      label = 'IN STOCK';
      fg = ProductTokens.green;
      bg = ProductTokens.greenBg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Single product row card — name, category/brand, SKU, price,
/// units available, edit/delete actions. No product image.
class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCardWidget({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProductTokens.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StockStatusBadge(quantity: product.quantity),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: ProductTokens.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.categoryName ?? ''} • ${product.brandName ?? ''}',
                      style: const TextStyle(
                        color: ProductTokens.labelGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.sku ?? '',
                      style: const TextStyle(
                        color: Color(0xFFAEB4BC),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${product.salePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: ProductTokens.navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Divider(height: 18, color: ProductTokens.borderGrey),
          Row(
            children: [
              Text(
                '${product.quantity} Units available',
                style:
                    const TextStyle(color: ProductTokens.labelGrey, fontSize: 12),
              ),
              const Spacer(),
              InkWell(
                onTap: onEdit,
                child: const Icon(Icons.edit_outlined,
                    size: 18, color: ProductTokens.labelGrey),
              ),
              const SizedBox(width: 14),
              InkWell(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline,
                    size: 18, color: ProductTokens.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
