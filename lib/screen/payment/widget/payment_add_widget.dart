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
  final _formKey = GlobalKey<FormState>();
  final ctr = Get.find<PaymentController>();

  final amountCtr = TextEditingController();
  final refCtr = TextEditingController();
  final noteCtr = TextEditingController();
  final customerCtr = TextEditingController();

  String? selectedInvoice;
  String selectedMethod = 'Bank Transfer';
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    amountCtr.dispose();
    refCtr.dispose();
    noteCtr.dispose();
    customerCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add Payment",
          style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Invoice Number"),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Select active invoice"),
                  value: selectedInvoice,
                  validator: (val) => val == null ? "Please select an invoice" : null,
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
                const SizedBox(height: 16),

                _buildLabel("Customer Name"),
                TextFormField(
                  controller: customerCtr,
                  validator: (val) => (val == null || val.isEmpty) ? "Customer name required" : null,
                  decoration: _inputDecoration("Industrial Solutions Ltd."),
                ),
                const SizedBox(height: 16),

                _buildLabel("Amount to Pay (\$USD)"),
                TextFormField(
                  controller: amountCtr,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Amount is required";
                    if (double.tryParse(val) == null) return "Enter valid number";
                    return null;
                  },
                  decoration: _inputDecoration("0.00").copyWith(
                    prefixIcon: const Icon(Icons.attach_money_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel("Payment Method"),
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  decoration: _inputDecoration("Select Method"),
                  items: ["Bank Transfer", "Cash Riel", "ABA PAY", "Credit Card"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedMethod = val!),
                ),
                const SizedBox(height: 16),

                _buildLabel("Payment Date"),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
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
                    decoration: _inputDecoration("Select Date").copyWith(
                      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                    ),
                    child: Text(DateFormat('dd / MM / yyyy').format(selectedDate)),
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel("Reference Number"),
                TextFormField(
                  controller: refCtr,
                  decoration: _inputDecoration("e.g. TXN-987243"),
                ),
                const SizedBox(height: 16),

                _buildLabel("Note"),
                TextFormField(
                  controller: noteCtr,
                  maxLines: 3,
                  decoration: _inputDecoration("Optional internal comments..."),
                ),
                const SizedBox(height: 28),

                // Form Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003B6D),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
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
                          }
                        },
                        child: const Text(
                          "Save Payment",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF374151)),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF003B6D), width: 1.5),
      ),
    );
  }
}