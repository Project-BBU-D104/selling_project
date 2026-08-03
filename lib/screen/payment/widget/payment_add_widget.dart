import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/payment_controller.dart';
import 'package:selling_project/models/payment_model.dart';

class PaymentAddWidget extends StatefulWidget {
  const PaymentAddWidget({super.key});

  @override
  State<PaymentAddWidget> createState() => _PaymentAddWidgetState();
}

class _PaymentAddWidgetState extends State<PaymentAddWidget> {
  final ctr = Get.find<PaymentController>();

  final amountCtr = TextEditingController();
  final refCtr = TextEditingController();
  final noteCtr = TextEditingController();
  final customerCtr = TextEditingController();

  String? selectedInvoice;
  String selectedMethod = 'Bank Transfer';
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Payment", style: TextStyle(color: Color(0xFF003B6D), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Invoice Number"),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Select an active invoice"),
              items: ["#INV-2023-001", "#INV-2023-002"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedInvoice = val;
                  customerCtr.text = "Industrial Solutions Ltd.";
                });
              },
            ),
            const SizedBox(height: 12),

            _buildLabel("Customer Name"),
            TextField(
              controller: customerCtr,
              decoration: _inputDecoration("Industrial Solutions Ltd."),
            ),
            const SizedBox(height: 12),

            _buildLabel("Amount to Pay"),
            TextField(
              controller: amountCtr,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("USD 0.00"),
            ),
            const SizedBox(height: 12),

            _buildLabel("Payment Method"),
            DropdownButtonFormField<String>(
              initialValue: selectedMethod,
              decoration: _inputDecoration(""),
              items: ["Bank Transfer", "Cash Riel", "ABA PAY", "Credit Card"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedMethod = val!),
            ),
            const SizedBox(height: 12),

            _buildLabel("Payment Date"),
            InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: InputDecorator(
                decoration: _inputDecoration("").copyWith(
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
                child: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
              ),
            ),
            const SizedBox(height: 12),

            _buildLabel("Reference Number"),
            TextField(
              controller: refCtr,
              decoration: _inputDecoration("TXN-987243"),
            ),
            const SizedBox(height: 12),

            _buildLabel("Note"),
            TextField(
              controller: noteCtr,
              maxLines: 3,
              decoration: _inputDecoration("Optional Internal Comments.."),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7D7D),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003B6D),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      final newPayment = PaymentModel(
                        saleId: selectedInvoice ?? 'SALE_001',
                        paymentMethod: selectedMethod,
                        amount: double.tryParse(amountCtr.text) ?? 0.0,
                        referenceNo: refCtr.text,
                        note: noteCtr.text,
                        paymentDate: selectedDate,
                      );
                      ctr.addPayment(newPayment);
                      Get.back();
                    },
                    child: const Text("Save Payment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }
}