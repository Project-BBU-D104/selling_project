import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';

class StockAdjustmentCardWidget extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const StockAdjustmentCardWidget({super.key, required this.adjustment});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockAdjustmentController>();
    final productCtrl = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    final matchedProduct = productCtrl.product.firstWhereOrNull(
      (p) => p.id == adjustment.productId,
    );

    final displayName = (adjustment.productName != null && adjustment.productName!.isNotEmpty)
        ? adjustment.productName!
        : (matchedProduct?.productName ?? 'Unknown Product');

    final bool isAdd = adjustment.adjustmentType == 'ADD';
    final String formattedDate = adjustment.adjustmentDate != null
        ? DateFormat('dd-MM-yyyy HH:mm').format(adjustment.adjustmentDate!)
        : 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => _showDetailDialog(context, displayName, formattedDate, isAdd),
        leading: CircleAvatar(
          backgroundColor: isAdd ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(
            isAdd ? Icons.add : Icons.remove,
            color: isAdd ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (adjustment.reason != null && adjustment.reason!.isNotEmpty)
              Text('Reason: ${adjustment.reason}'),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isAdd ? '+' : '-'}${adjustment.quantity}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAdd ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 4),
            // 📌 Delete button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(
    BuildContext context,
    String productName,
    String formattedDate,
    bool isAdd,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Adjustment Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Product Name:', productName),
            _detailRow('Type:', isAdd ? 'Add Stock (+)' : 'Remove Stock (-)'),
            _detailRow('Quantity:', '${adjustment.quantity}'),
            _detailRow(
              'Reason:',
              (adjustment.reason != null && adjustment.reason!.isNotEmpty)
                  ? adjustment.reason!
                  : 'None',
            ),
            if (adjustment.userName != null && adjustment.userName!.isNotEmpty)
              _detailRow('Updated By:', adjustment.userName!),
            _detailRow('Date:', formattedDate),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // 💡 Confirm delete dialog
  void _confirmDelete(BuildContext context, StockAdjustmentController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this stock adjustment data?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.back();
              if (adjustment.id != null) {
                controller.deleteAdjustment(adjustment.id!);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}