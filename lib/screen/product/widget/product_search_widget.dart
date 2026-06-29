import 'package:flutter/material.dart';
import 'product_tokens.dart';

/// Search input box shown at the top of the product list.
class ProductSearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const ProductSearchWidget({
    Key? key,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search products...',
        hintStyle: const TextStyle(color: ProductTokens.hintGrey),
        prefixIcon: const Icon(Icons.search, color: ProductTokens.hintGrey),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ProductTokens.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ProductTokens.borderGrey),
        ),
      ),
    );
  }
}

/// Horizontal filter chip row ("All Products", "Category: GPU", etc.)
/// Kept in the same file as the search bar since both belong to the
/// "search & filter" concern of the list screen.
class ProductFilterChips extends StatelessWidget {
  final List<Map<String, dynamic>> filters;

  const ProductFilterChips({
    Key? key,
    this.filters = const [
      {'label': 'All Products', 'selected': true, 'closable': true},
      {'label': 'Category: GPU', 'selected': false, 'closable': false},
      {'label': 'Brand: NVIDIA', 'selected': false, 'closable': false},
      {'label': 'Stock: Low', 'selected': false, 'closable': false},
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter['selected'] as bool;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? ProductTokens.chipSelectedFill
                  : ProductTokens.chipFill,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter['label'] as String,
                  style: TextStyle(
                    color:
                        selected ? ProductTokens.navy : ProductTokens.labelGrey,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (filter['closable'] as bool) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.close, size: 14, color: ProductTokens.navy),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
