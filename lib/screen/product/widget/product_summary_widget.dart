import 'package:flutter/material.dart';
import 'product_tokens.dart';

/// Top header for the product screen: back button (in a light circle),
/// bold title, search icon, and notification bell — matches the
/// "Customer" screen header style.
class ProductSummaryWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const ProductSummaryWidget({
    Key? key,
    this.title = 'Product',
    this.onBackTap,
    this.onSearchTap,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          InkWell(
            onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F3F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: ProductTokens.navy, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: ProductTokens.navy,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          InkWell(
            onTap: onSearchTap,
            child: const Icon(Icons.search, color: ProductTokens.navy, size: 22),
          ),
          const SizedBox(width: 18),
          InkWell(
            onTap: onNotificationTap,
            child: const Icon(Icons.notifications_none, color: ProductTokens.navy, size: 22),
          ),
        ],
      ),
    );
  }
}
