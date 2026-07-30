import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/purchase_controller.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/models/supplier_model.dart';

class PurchaseAddWidget extends StatefulWidget {
  const PurchaseAddWidget({super.key});

  @override
  State<PurchaseAddWidget> createState() => _PurchaseAddWidgetState();
}

class _PurchaseAddWidgetState extends State<PurchaseAddWidget> {
  final ctr = Get.find<PurchaseController>();

  final poNoCtr = TextEditingController(text: "PO-2026-001");
  final qtyCtr = TextEditingController(text: "1");
  final priceCtr = TextEditingController(text: "0.00");

  DateTime? refDate = DateTime.now();
  DateTime? expDeliveryDate;

  @override
  void initState() {
    super.initState();
    ctr.clearForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text("Add Purchase", style: TextStyle(color: Color(0xFF003B6D), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add Purchase Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(height: 24),
              _buildLabel("Supplier Name"),
              Obx(() => DropdownButtonFormField<SupplierModel>(
                value: ctr.selectedSupplier.value,
                hint: const Text("Select Supplier"),
                decoration: _inputDecoration(""),
                items: ctr.supplierDropdownItems,
                onChanged: (val) => ctr.selectedSupplier.value = val,
              )),
              const SizedBox(height: 12),

              _buildLabel("# Reference / PO Number"),
              TextField(controller: poNoCtr, decoration: _inputDecoration("PO-2026-001")),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Reference Date"),
                        InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: refDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) setState(() => refDate = picked);
                          },
                          child: InputDecorator(
                            decoration: _inputDecoration("").copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
                            child: Text(refDate == null ? "dd/mm/yyyy" : DateFormat('dd/MM/yyyy').format(refDate!)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Exp. Delivery"),
                        InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) setState(() => expDeliveryDate = picked);
                          },
                          child: InputDecorator(
                            decoration: _inputDecoration("").copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
                            child: Text(expDeliveryDate == null ? "dd/mm/yyyy" : DateFormat('dd/MM/yyyy').format(expDeliveryDate!)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Purchase Items", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003B6D))),
                  GestureDetector(
                    onTap: () {
                      int q = int.tryParse(qtyCtr.text) ?? 1;
                      double p = double.tryParse(priceCtr.text) ?? 0.0;
                      ctr.addTempItem(q, p);
                      qtyCtr.text = "1";
                      priceCtr.text = "0.00";
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF003B6D)),
                        SizedBox(width: 4),
                        Text("Add Item", style: TextStyle(color: Color(0xFF003B6D), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Select Product"),
                    Obx(() => DropdownButtonFormField<ProductModel>(
                      value: ctr.selectedProduct.value,
                      hint: const Text("Select Product"),
                      decoration: _inputDecoration(""),
                      items: ctr.productDropdownItems,
                      onChanged: (val) {
                        ctr.selectedProduct.value = val;
                        if (val != null) {
                          priceCtr.text = (val.costPrice ?? val.price ?? 0.0).toString();
                        }
                      },
                    )),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Quantity"),
                              TextField(controller: qtyCtr, keyboardType: TextInputType.number, decoration: _inputDecoration("1")),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Unit Price (\$)"),
                              TextField(controller: priceCtr, keyboardType: TextInputType.number, decoration: _inputDecoration("0.00")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ITEM LIST
              Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ctr.tempItems.length,
                itemBuilder: (context, index) {
                  final item = ctr.tempItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.productName ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${item.quantity} x \$${item.unitPrice.toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("\$${item.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => ctr.removeTempItem(index),
                        ),
                      ],
                    ),
                  );
                },
              )),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004B87), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    if (ctr.selectedSupplier.value == null) {
                      Get.snackbar("Error", "Please select supplier");
                      return;
                    }
                    if (ctr.tempItems.isEmpty) {
                      Get.snackbar("Error", "Please add at least one item");
                      return;
                    }

                    await ctr.submitPurchase(
                      invoiceNo: poNoCtr.text,
                      refDate: refDate ?? DateTime.now(),
                      expDeliveryDate: expDeliveryDate,
                    );
                    Get.back();
                  },
                  child: const Text("Save Purchase", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey.shade700)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }
}