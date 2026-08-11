import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';
import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/screen/stock_adjustment/widget/stock_adjustment_add_widget.dart';
import 'package:selling_project/screen/stock_adjustment/widget/stock_adjustment_card_widget.dart';

class StockAdjustmentScreen extends StatelessWidget {
  const StockAdjustmentScreen({super.key});

  // មុខងារសម្រាប់បែងចែកចំណងជើងតាមថ្ងៃខែ
  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);

    if (aDate == today) {
      return 'TODAY';
    } else if (aDate == today.subtract(const Duration(days: 1))) {
      return 'YESTERDAY';
    } else {
      return DateFormat('dd MMM yyyy').format(date).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<StockAdjustmentController>()
        ? Get.find<StockAdjustmentController>()
        : Get.put(StockAdjustmentController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Stock Adjustments',
          style: TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFFF0F4F8),
              child: Icon(Icons.person_outline, color: Color(0xFF0F2C59)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004C87),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Get.bottomSheet(
            const StockAdjustmentAddWidget(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildSummaryCard(controller.stockAdjustments)),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.stockAdjustments.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No stock adjustments found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              // ធ្វើការจัดกลุ่ม (Group) ទិន្នន័យតាមកាលបរិច្ឆេទ
              Map<String, List<StockAdjustmentModel>> groupedMap = {};
              for (var item in controller.stockAdjustments) {
                // ប្រើ adjustmentDate ឬ createdAt
                DateTime date = item.adjustmentDate ?? item.createdAt ?? DateTime.now();
                String headerKey = _getDateHeader(date);
                if (groupedMap[headerKey] == null) {
                  groupedMap[headerKey] = [];
                }
                groupedMap[headerKey]!.add(item);
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupedMap.keys.length,
                itemBuilder: (context, index) {
                  String key = groupedMap.keys.elementAt(index);
                  List<StockAdjustmentModel> listForDate = groupedMap[key]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          key,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      ...listForDate.map((adjustment) {
                        return StockAdjustmentCardWidget(adjustment: adjustment);
                      }).toList(),
                    ],
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(List<StockAdjustmentModel> list) {
    int totalUnits = 0;
    int subtractedUnits = 0;

    for (var item in list) {
      if (item.adjustmentType == 'ADD') {
        totalUnits += item.quantity;
      } else {
        totalUnits -= item.quantity;
        subtractedUnits += item.quantity;
      }
    }
    double totalSystemStock = 1000.0;
    double shrinkageRate = totalSystemStock > 0
        ? (subtractedUnits / totalSystemStock) * 100
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF004C87),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Activity",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            '${list.length} Stock Adjustments\nProcessed',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Variance',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${totalUnits >= 0 ? '+' : ''}$totalUnits Units',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Container(width: 1, height: 28, color: Colors.white30),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shrinkage Rate',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${shrinkageRate.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}