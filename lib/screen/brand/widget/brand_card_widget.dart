import 'package:flutter/material.dart';
import 'package:selling_project/models/product_management/brand_model.dart';

class BrandCardWidget extends StatelessWidget {
  final BrandModel brand;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const BrandCardWidget({
    super.key,
    required this.brand,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          brand.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(brand.description),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: const Icon(Icons.edit, color: Colors.blueAccent),
            //   onPressed: onEdit,
            // ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}