import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';

class SaleDetailScreen extends StatelessWidget {
  final String saleId;
  final String invoiceNo;
  final double subtotal;
  final double totalAmount;

  SaleDetailScreen({
    super.key,
    required this.saleId,
    required this.invoiceNo,
    required this.subtotal,
    required this.totalAmount,
  });

  final SaleController ctr = Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Order", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (ctr.loadingItems.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final customer = ctr.customer.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ផ្នែក CUSTOMER SECTION (រូបភាពទី៣)
              const Text("CUSTOMER", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0.5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(Icons.person, color: Color(0xFF004C87)),
                  ),
                  title: Text(
                    customer != null ? customer.customerName : "General Customer",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(customer != null ? "Phone: ${customer.phone}" : "No Account ID"),
                  trailing: const Icon(Icons.edit, size: 20, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // ផ្នែក ITEMS LIST SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ITEMS (${ctr.saleItems.length})", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                  TextButton(onPressed: () {}, child: const Text("+ Add Items", style: TextStyle(fontSize: 12))),
                ],
              ),
              if (ctr.saleItems.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text("No items found in this invoice")),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ctr.saleItems.length,
                  itemBuilder: (context, index) {
                    final item = ctr.saleItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(height: 4),
                                  Text("${item.quantity} Unit • \$${item.unitPrice.toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                ],
                              ),
                            ),
                            Text("\$${item.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),

              // ផ្នែក PAYMENT METHOD (រូបភាពទី៣)
              const Text("PAYMENT METHOD", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildPaymentTypeCard(Icons.money, "Cash", false),
                  _buildPaymentTypeCard(Icons.credit_card, "Card", true), // សន្មតថាជ្រើសរើសយកកាតជម្រើសពិត
                  _buildPaymentTypeCard(Icons.qr_code, "Digital", false),
                ],
              ),
              const SizedBox(height: 20),

              // ផ្នែកតម្លៃលម្អិត ORDER SUMMARY BOX
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}", isBold: false),
                    _buildSummaryRow("Tax (8.25%)", "\$${(subtotal * 0.0825).toStringAsFixed(2)}", isBold: false),
                    _buildSummaryRow("Discount", "-\$0.00", isBold: false, color: Colors.red),
                    const Divider(height: 24),
                    _buildSummaryRow("Total Amount", "\$${totalAmount.toStringAsFixed(2)}", isBold: true, fontSize: 22, color: const Color(0xFF004C87)),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // ប៊ូតុងចុងក្រោយ CONFIRM & PAY BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar("Invoice Status", "This order is successfully processed.");
                  },
                  icon: const Icon(Icons.verified_user, color: Colors.white),
                  label: const Text("Confirm & Pay", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004C87),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(child: Text("Processing through Secure Gateway V2.1", style: TextStyle(color: Colors.grey, fontSize: 11))),
            ],
          ),
        );
      }),
    );
  }

  // Widget ជំនួយសម្រាប់បង្កើតប៊ូតុង Payment Method
  Widget _buildPaymentTypeCard(IconData icon, String label, bool isSelected) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF004C87) : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF004C87) : Colors.black54),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF004C87) : Colors.black87)),
          ],
        ),
      ),
    );
  }

  // Widget ជំនួយសម្រាប់បង្ហាញតម្លៃជួរនីមួយៗ
  Widget _buildSummaryRow(String title, String value, {required bool isBold, double fontSize = 14, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color != Colors.red ? Colors.black54 : Colors.red)),
          Text(value, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color ?? Colors.black87)),
        ],
      ),
    );
  }
}