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
  final _formKey = GlobalKey<FormState>();
  final ctr = Get.find<PaymentController>();

  late TextEditingController amountCtr;
  late TextEditingController refCtr;
  late TextEditingController noteCtr;
  late TextEditingController customerCtr;

  late String selectedMethod;
  late DateTime selectedDate;

  // បញ្ជី Method ដែលត្រឹមត្រូវ និងគ្រប់ជ្រុងជ្រោយ
  final List<String> paymentMethods = [
    "Cash Riel",
    "Cash USD",
    "ABA PAY",
    "Bank Transfer",
    "Credit Card"
  ];

  @override
  void initState() {
    super.initState();
    amountCtr = TextEditingController(text: widget.payment.amount.toString());
    refCtr = TextEditingController(text: widget.payment.referenceNo ?? '');
    noteCtr = TextEditingController(text: widget.payment.note ?? '');
    customerCtr = TextEditingController(text: widget.payment.customerName ?? '');

    // ការពារ Crash: បើ selectedMethod គ្មានក្នុង List ឱ្យ Default ទៅ Item ដំបូង
    if (paymentMethods.contains(widget.payment.paymentMethod)) {
      selectedMethod = widget.payment.paymentMethod;
    } else {
      selectedMethod = paymentMethods.first;
    }

    selectedDate = widget.payment.paymentDate;
  }

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
          "Edit Payment",
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
                // 1. Invoice Number (Read-only ព្រោះការ Edit Payment មិនគួរឱ្យប្តូរ Invoice ID ទេ)
                _buildLabel("Invoice Number"),
                TextFormField(
                  initialValue: widget.payment.invoiceNo ?? widget.payment.saleId,
                  readOnly: true,
                  decoration: _inputDecoration("").copyWith(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Customer Name
                _buildLabel("Customer Name"),
                TextFormField(
                  controller: customerCtr,
                  validator: (val) => (val == null || val.isEmpty) ? "Customer name required" : null,
                  decoration: _inputDecoration("Enter customer name"),
                ),
                const SizedBox(height: 16),

                // 3. Amount to Pay
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

                // 4. Payment Method
                _buildLabel("Payment Method"),
                DropdownButtonFormField<String>(
                  isExpanded: true, // Fix: ការពារ Overflow
                  value: selectedMethod,
                  decoration: _inputDecoration("Select Method"),
                  items: paymentMethods
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedMethod = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // 5. Payment Date
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
                    decoration: _inputDecoration("").copyWith(
                      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                    ),
                    child: Text(DateFormat('dd / MM / yyyy').format(selectedDate)),
                  ),
                ),
                const SizedBox(height: 16),

                // 6. Reference Number
                _buildLabel("Reference Number (Optional)"),
                TextFormField(
                  controller: refCtr,
                  decoration: _inputDecoration("e.g. TXN-987243"),
                ),
                const SizedBox(height: 16),

                // 7. Note
                _buildLabel("Note (Optional)"),
                TextFormField(
                  controller: noteCtr,
                  maxLines: 3,
                  decoration: _inputDecoration("Optional comments..."),
                ),
                const SizedBox(height: 28),

                // Actions
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
                            final updated = PaymentModel(
                              id: widget.payment.id,
                              saleId: widget.payment.saleId,
                              invoiceNo: widget.payment.invoiceNo,
                              customerName: customerCtr.text,
                              paymentMethod: selectedMethod,
                              amount: double.tryParse(amountCtr.text) ?? 0.0,
                              referenceNo: refCtr.text,
                              note: noteCtr.text,
                              status: widget.payment.status,
                              paymentDate: selectedDate,
                            );
                            ctr.updatePayment(updated);
                            Get.back();
                          }
                        },
                        child: const Text(
                          "Update Payment",
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