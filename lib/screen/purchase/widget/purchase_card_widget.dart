import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/purchase_controller.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';

class PurchaseCardWidget extends StatelessWidget {
  final PurchaseModel purchase;
  final VoidCallback? onTap;

  const PurchaseCardWidget({
    super.key,
    required this.purchase,
    this.onTap,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase().trim()) {
      case 'received':
      case 'completed':
        return const Color(0xFF2E7D32);
      case 'in transit':
      case 'pending':
        return const Color(0xFFF57C00);
      case 'cancelled':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String? status) {
    switch (status?.toLowerCase().trim()) {
      case 'received':
        return Icons.business;
      case 'in transit':
        return Icons.settings;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.build;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PurchaseController controller = Get.find<PurchaseController>();
    final isPending = (purchase.status.toLowerCase().trim() == 'pending' ||
        purchase.status.toLowerCase().trim() == 'in transit');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_getIcon(purchase.status), color: const Color(0xFF003B6D)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purchase.supplierName ?? 'Supplier Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          purchase.invoiceNo,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(purchase.status),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              purchase.status,
                              style: TextStyle(
                                color: _getStatusColor(purchase.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${purchase.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF003B6D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(purchase.purchaseDate),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              if (isPending) ...[
                const Divider(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                        title: "Confirm Delivery",
                        middleText: "Are you sure you have received this delivery?",
                        textConfirm: "Received",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white,
                        buttonColor: const Color(0xFF003B6D),
                        onConfirm: () {
                          Get.back();
                          controller.markAsReceived(purchase);
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
                          SizedBox(width: 4),
                          Text(
                            "Mark Received",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}