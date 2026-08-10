import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/screen/stock_adjustment/widget/stock_adjustment_detail_widget.dart';

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
    final sign = isAdd ? '+' : '-';
    final iconColor = isAdd ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final badgeColor = isAdd ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Get.bottomSheet(
            StockAdjustmentDetailWidget(
              adjustment: adjustment,
              resolvedProductName: displayName,
            ),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isAdd ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F2C59)),
              ),
            ),
            Text(
              '$sign${adjustment.quantity}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: iconColor,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  adjustment.reason != null && adjustment.reason!.isNotEmpty
                      ? adjustment.reason!
                      : 'General',
                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
              Text(
                adjustment.adjustmentDate != null
                    ? DateFormat('hh:mm a').format(adjustment.adjustmentDate!)
                    : 'Just now',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: () => _confirmDelete(context, controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, StockAdjustmentController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this stock adjustment record?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
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