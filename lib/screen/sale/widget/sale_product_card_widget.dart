import 'package:flutter/material.dart';
import 'package:selling_project/models/product_management/product_model.dart';

class SaleProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAdd;

  const SaleProductCardWidget({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Product Image Container
          Expanded(
            flex: 3, // កំណត់សមាមាត្រទំហំរូបភាព
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildProductImage(product.imageUrl),
              ),
            ),
          ),

          // 📝 Product Details Section
          Expanded(
            flex: 2, // កំណត់សមាមាត្រទំហំអត្ថបទ
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description ?? 'No specs available',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                  const Spacer(), // រុញតម្លៃនិងប៊ូតុងឱ្យមកក្រោមสุดជាប្រក្រតី
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      Material(
                        color: const Color(0xFF004C87),
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          onTap: onAdd,
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Safe Network Image Loader with Auto-Fallback
  Widget _buildProductImage(String? imageUrl) {
    final cleanUrl = imageUrl?.trim();

    if (cleanUrl != null && cleanUrl.isNotEmpty && _isValidUri(cleanUrl)) {
      return Image.network(
        cleanUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  /// Helper to validate network image string format
  bool _isValidUri(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  /// Fallback Placeholder Widget
  Widget _buildPlaceholder() {
    return Image.asset(
      'assets/images/placeholder.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade100,
          child: const Center(
            child: Icon(
              Icons.laptop,
              size: 36,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}