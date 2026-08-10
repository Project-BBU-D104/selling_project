import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';

class StockAdjustmentDetailWidget extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const StockAdjustmentDetailWidget({
    super.key,
    required this.adjustment,
  });

  @override
  Widget build(BuildContext context) {
    bool isAdd = adjustment.adjustmentType == 'ADD';
    Color themeColor = isAdd ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stock Adjustment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const Divider(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: themeColor.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAdd ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: themeColor,
                ),
                const SizedBox(width: 4),
                Text(
                  isAdd ? 'Add (+)' : 'Subtract (-)',
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.inventory_2_outlined,
            label: 'Product Name',
            value: adjustment.productName ?? 'Unknown',
          ),
          _buildDetailRow(
            icon: Icons.format_list_numbered,
            label: 'Adjustment Quantity',
            value: '${isAdd ? '+' : '-'}${adjustment.quantity}',
            valueColor: themeColor,
            isBold: true,
          ),
          _buildDetailRow(
            icon: Icons.notes,
            label: 'Reason',
            value: (adjustment.reason != null && adjustment.reason!.isNotEmpty)
                ? adjustment.reason!
                : 'No information available',
          ),
          _buildDetailRow(
            icon: Icons.person_outline,
            label: 'User',
            value: adjustment.userName ?? adjustment.userId ?? 'N/A',
          ),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Adjustment Date',
            value: adjustment.adjustmentDate != null
                ? DateFormat('dd-MM-yyyy hh:mm a').format(adjustment.adjustmentDate!)
                : 'N/A',
          ),
          if (adjustment.createdAt != null)
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Created Date',
              value: DateFormat('dd-MM-yyyy hh:mm a').format(adjustment.createdAt!),
            ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                elevation: 0,
              ),
              onPressed: () => Get.back(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}