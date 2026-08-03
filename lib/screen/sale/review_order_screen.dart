import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/routes/app_route.dart';

class ReviewOrderScreen extends StatelessWidget {
  const ReviewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Safely retrieve SaleModel arguments
    final SaleModel? saleData =
        Get.arguments is SaleModel ? Get.arguments as SaleModel : null;

    // Validation: Return early if no order data is present
    if (saleData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Review Order"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(
          child: Text(
            "មិនមានទិន្នន័យការបញ្ជាទិញឡើយ (No Order Data)",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // 2. Reactive payment method state
    final RxString selectedPaymentMethod = 'Cash'.obs;
    final List<dynamic> itemList = saleData.items ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Review Order",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CUSTOMER SECTION
              const Text(
                "CUSTOMER",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (saleData.customerId?.isNotEmpty ?? false)
                                ? saleData.customerId!
                                : "General Customer",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Premium Account . ID: 88291",
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black54,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. ITEMS SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ITEMS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Text(
                      "+ Add Items",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Items List with null-safety
              if (itemList.isNotEmpty)
                ...itemList.map((item) => _buildItemCard(item))
              else
                _buildDefaultItemCard(
                  "MacBook Pro M2 14\"",
                  "1 Unit . \$1,599.99",
                  "\$1,599.99",
                ),

              const SizedBox(height: 20),

              // 3. PAYMENT METHOD SECTION
              const Text(
                "PAYMENT METHOD",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildPaymentMethodCard(
                    "Cash",
                    Icons.payments_outlined,
                    selectedPaymentMethod,
                  ),
                  const SizedBox(width: 8),
                  _buildPaymentMethodCard(
                    "Card",
                    Icons.credit_card,
                    selectedPaymentMethod,
                  ),
                  const SizedBox(width: 8),
                  _buildPaymentMethodCard(
                    "Digital",
                    Icons.qr_code_scanner,
                    selectedPaymentMethod,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 4. SUMMARY CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      "Subtotal",
                      "\$${(saleData.subtotal ?? 0.0).toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 6),
                    _buildSummaryRow(
                      "Tax (8.25%)",
                      "\$${(saleData.tax ?? 0.0).toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 6),
                    _buildSummaryRow(
                      "Discount (5%)",
                      "-\$${(saleData.discount ?? 0.0).toStringAsFixed(2)}",
                      isDiscount: true,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Colors.black12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "\$${(saleData.totalAmount ?? 0.0).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF3B1EFA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. CONFIRM & PAY BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B1EFA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    saleData.paymentMethod = selectedPaymentMethod.value;
                    saleData.paymentStatus = "Paid";

                    Get.offNamed(
                      AppRoute.SalesCompletionScreen,
                      arguments: saleData,
                    );
                  },
                  child: const Text(
                    "Confirm & Pay",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    String title,
    IconData icon,
    RxString selectedMethod,
  ) {
    return Expanded(
      child: Obx(() {
        final bool isSelected = selectedMethod.value == title;
        return GestureDetector(
          onTap: () => selectedMethod.value = title,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3B1EFA)
                    : Colors.black.withValues(alpha: 0.08),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? const Color(0xFF3B1EFA) : Colors.black87,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelected ? const Color(0xFF3B1EFA) : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDiscount ? Colors.red.shade300 : Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.red.shade400 : Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(dynamic item) {
    if (item == null) return const SizedBox.shrink();

    double itemPrice = 0.0;
    int quantity = 1;
    String productName = "Unknown Product";

    try {
      // Safely parse price from common field names
      final rawPrice = item?.unitPrice ?? item?.price ?? item?.sellPrice;
      if (rawPrice != null) {
        itemPrice = double.tryParse(rawPrice.toString()) ?? 0.0;
      }

      // Safely parse quantity
      final rawQty = item?.quantity ?? item?.qty;
      if (rawQty != null) {
        quantity = int.tryParse(rawQty.toString()) ?? 1;
      }

      // Safely extract product name
      final rawName = item?.productName ?? item?.name ?? item?.title;
      if (rawName != null) {
        productName = rawName.toString();
      }
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.laptop, size: 30, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$quantity Unit . \$${itemPrice.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            "\$${(quantity * itemPrice).toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultItemCard(String title, String subtitle, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.laptop_mac,
              size: 32,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}