import 'package:flutter/material.dart';
import 'package:selling_project/models/sale/sale_items_model.dart';

class SaleItemTileWidget extends StatelessWidget {
  final SaleItemModel item;

  const SaleItemTileWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.categoryName,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text("Qty: ${item.quantity}", style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 15),
                      Text("Price: \$${item.unitPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              "\$${item.totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}