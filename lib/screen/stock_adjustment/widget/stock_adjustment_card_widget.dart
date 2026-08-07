import 'package:flutter/material.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';

class StockAdjustmentCardWidget extends StatelessWidget {
  final StockAdjustmentModel adjustment;
  final VoidCallback onDelete;

  const StockAdjustmentCardWidget({
    super.key,
    required this.adjustment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool isDecrease = adjustment.adjustmentType == 'Decrease';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: isDecrease ? Colors.red.shade50 : Colors.green.shade50,
          child: Icon(
            isDecrease ? Icons.arrow_downward : Icons.arrow_upward,
            color: isDecrease ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          adjustment.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Reason: ${adjustment.reason}", style: const TextStyle(color: Colors.grey)),
            Text("Desc: ${adjustment.description}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              "Date: ${adjustment.adjustmentDate.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${isDecrease ? '-' : '+'}${adjustment.quantity}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDecrease ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}