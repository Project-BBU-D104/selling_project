import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'package:selling_project/models/sale/sale_items_model.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/utils/print_helper.dart'; // 📌 នាំចូល PrintHelper ដែលបានបង្កើតថ្មី

class ReviewOrderScreen extends StatelessWidget {
  const ReviewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SaleController saleController = Get.find<SaleController>();
    final SaleModel? saleData =
        Get.arguments is SaleModel ? Get.arguments as SaleModel : null;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (saleData.customerName != null && saleData.customerName!.isNotEmpty) {
        saleController.selectedCustomerName.value = saleData.customerName!;
      }
      if (saleData.customerId != null && saleData.customerId!.isNotEmpty) {
        saleController.selectedCustomerId.value = saleData.customerId!;
      }
    });

    final RxString selectedPaymentMethod = 'Cash'.obs;
    final List<SaleItemModel> itemList = saleData.items ?? [];

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
                      child: Obx(() {
                        final String currentName =
                            saleController.selectedCustomerName.value.isNotEmpty
                                ? saleController.selectedCustomerName.value
                                : "General Customer";

                        final String currentId =
                            saleController.selectedCustomerId.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentId.isNotEmpty
                                  ? "Customer ID: $currentId"
                                  : "Standard Account",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black54,
                        size: 20,
                      ),
                      onPressed: () {
                        saleController.openCustomerSelectBottomSheet();
                      },
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

              if (itemList.isNotEmpty)
                ...itemList.map((item) => _buildItemCard(item))
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No items in cart",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // 3. PAYMENT METHOD
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
                      "\$${saleData.subtotal.toStringAsFixed(2)}",
                    ),
                    if (saleData.tax > 0) ...[
                      const SizedBox(height: 6),
                      _buildSummaryRow(
                        "Tax",
                        "\$${saleData.tax.toStringAsFixed(2)}",
                      ),
                    ],
                    if (saleData.discount > 0) ...[
                      const SizedBox(height: 6),
                      _buildSummaryRow(
                        "Discount",
                        "-\$${saleData.discount.toStringAsFixed(2)}",
                        isDiscount: true,
                      ),
                    ],
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
                          "\$${saleData.totalAmount.toStringAsFixed(2)}",
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

              // Confirm & Pay Button
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
                  onPressed: () async {
                    saleData.customerName =
                        saleController.selectedCustomerName.value;
                    saleData.customerId =
                        saleController.selectedCustomerId.value.isNotEmpty
                            ? saleController.selectedCustomerId.value
                            : null;

                    saleData.paymentMethod = selectedPaymentMethod.value;
                    saleData.paymentStatus = "Paid";
                    saleData.saleDate = DateTime.now();

                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    try {
                      bool isSuccess =
                          await saleController.createSale(saleData);

                      if (Get.isDialogOpen ?? false) Get.back();

                      if (isSuccess) {
                        Get.offNamed(
                          AppRoute.SalesCompletionScreen,
                          arguments: saleData,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Failed to save order to Firebase",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade400,
                          colorText: Colors.white,
                        );
                      }
                    } catch (e) {
                      if (Get.isDialogOpen ?? false) Get.back();
                      Get.snackbar(
                        "Error",
                        "Something went wrong: $e",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade400,
                        colorText: Colors.white,
                      );
                    }
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
              const SizedBox(height: 12),

              // 🖨️ Print Receipt Button (ហៅប្រើពី PrintHelper ត្រង់នេះ)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => PrintHelper.showPrintOptionsModal(context, saleData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Print Receipt",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

  Widget _buildItemCard(SaleItemModel item) {
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
            clipBehavior: Clip.antiAlias,
            child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.laptop, size: 28, color: Colors.black54),
                  )
                : const Icon(Icons.laptop, size: 28, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${item.quantity} Unit . \$${item.unitPrice.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            "\$${(item.totalPrice).toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}