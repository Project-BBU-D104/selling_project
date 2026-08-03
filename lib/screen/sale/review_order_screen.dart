import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/sale/sale_model.dart';
import '../../routes/app_route.dart';

class ReviewOrderScreen extends StatefulWidget {
  const ReviewOrderScreen({super.key});

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  SaleModel? saleData;
  String selectedPaymentMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is SaleModel) {
      saleData = Get.arguments as SaleModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (saleData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Review Order")),
        body: const Center(
          child: Text("មិនមានទិន្នន័យការបញ្ជាទិញឡើយ (No Order Data)"),
        ),
      );
    }

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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.08)),
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
                            saleData?.customerId ?? "Jonathan Sterling",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                      icon: const Icon(Icons.edit_outlined, color: Colors.black54, size: 20),
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
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "+ Add Items",
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // List ទំនិញ
              if (saleData?.items != null && saleData!.items!.isNotEmpty)
                ...saleData!.items!.map((item) => _buildItemCard(item))
              else
                _buildDefaultItemCard("MacBook Pro M2 14\"", "1 Unit . \$1,599.99", "\$1,599.99"),

              const SizedBox(height: 20),

              // 3. PAYMENT METHOD SECTION
              const Text(
                "PAYMENT METHOD",
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPaymentMethodCard("Cash", Icons.payments_outlined),
                  const SizedBox(width: 8),
                  _buildPaymentMethodCard("Card", Icons.credit_card),
                  const SizedBox(width: 8),
                  _buildPaymentMethodCard("Digital", Icons.qr_code_scanner),
                ],
              ),
              const SizedBox(height: 20),

              // 4. SUMMARY CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow("Subtotal", "\$${(saleData?.subtotal ?? 2188.99).toStringAsFixed(2)}"),
                    const SizedBox(height: 6),
                    _buildSummaryRow("Tax (8.25%)", "\$${(saleData?.tax ?? 180.59).toStringAsFixed(2)}"),
                    const SizedBox(height: 6),
                    _buildSummaryRow("Discount (5%)", "-\$${(saleData?.discount ?? 109.45).toStringAsFixed(2)}", isDiscount: true),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Colors.black12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          "\$${(saleData?.totalAmount ?? 2260.13).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF3B1EFA), // ពណ៌ Blue-Purple ដូចក្នុងរូប
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
                    backgroundColor: const Color(0xFF3B1EFA), // Blue-Purple color
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // 🟢 បច្ចុប្បន្នភាព Status មុននឹងបន្តទៅ Sales Completion
                    saleData?.paymentMethod = selectedPaymentMethod;
                    saleData?.paymentStatus = "Paid";

                    // 🚀 Navigate ទៅកាន់ Sales Completion (sale_detail_screen.dart)
                    Get.offNamed(AppRoute.saleDetailScreen, arguments: saleData);
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

  // Widget សម្រាប់ Payment Method Item
  Widget _buildPaymentMethodCard(String title, IconData icon) {
    bool isSelected = selectedPaymentMethod == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPaymentMethod = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF3B1EFA) : Colors.black.withOpacity(0.08),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF3B1EFA) : Colors.black87, size: 22),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF3B1EFA) : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget សម្រាប់ Row នៃ summary (Subtotal, Tax, Discount)
  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false}) {
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

  // Item Card dynamic ពី List
  Widget _buildItemCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
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
                  item.productName ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  "${item.quantity ?? 1} Unit . \$${(item.price ?? 0).toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            "\$${((item.quantity ?? 1) * (item.price ?? 0)).toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Item Card គំរូសម្រាប់ fallback UI
  Widget _buildDefaultItemCard(String title, String subtitle, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
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
            child: const Icon(Icons.laptop_mac, size: 32, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}