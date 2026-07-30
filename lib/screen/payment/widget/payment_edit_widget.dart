import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/payment_controller.dart';
import 'package:selling_project/models/payment_model.dart';

class PaymentEditWidget extends StatefulWidget {
  final PaymentModel payment;
  const PaymentEditWidget({super.key, required this.payment});

  @override
  State<PaymentEditWidget> createState() => _PaymentEditWidgetState();
}

class _PaymentEditWidgetState extends State<PaymentEditWidget> {
  final ctr = Get.find<PaymentController>();

  late TextEditingController amountCtr;
  late TextEditingController refCtr;
  late TextEditingController noteCtr;
  late TextEditingController customerCtr;

  late String selectedMethod;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    amountCtr = TextEditingController(text: widget.payment.amount.toString());
    refCtr = TextEditingController(text: widget.payment.referenceNo ?? '');
    noteCtr = TextEditingController(text: widget.payment.note ?? '');
    customerCtr = TextEditingController(text: widget.payment.customerName ?? 'Industrial Solutions Ltd.');
    selectedMethod = widget.payment.paymentMethod;
    selectedDate = widget.payment.paymentDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Payment", style: TextStyle(color: Color(0xFF003B6D), fontWeight: FontWeight.bold)),
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
              value: widget.payment.invoiceNo ?? "#INV-2023-001",
              decoration: _inputDecoration(""),
              items: ["#INV-2023-001", "#INV-2023-002"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 12),

            _buildLabel("Customer Name"),
            TextField(
              controller: customerCtr,
              decoration: _inputDecoration(""),
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
              value: selectedMethod,
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
                    child: const Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      final updated = PaymentModel(
                        id: widget.payment.id,
                        saleId: widget.payment.saleId,
                        paymentMethod: selectedMethod,
                        amount: double.tryParse(amountCtr.text) ?? 0.0,
                        referenceNo: refCtr.text,
                        note: noteCtr.text,
                        paymentDate: selectedDate,
                      );
                      ctr.updatePayment(updated);
                      Get.back();
                    },
                    child: const Text("Update Payment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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