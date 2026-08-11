import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/purchase_controller.dart';
import 'package:selling_project/models/product_management/product_model.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';
import 'package:selling_project/models/supplier_model.dart';

class PurchaseEditWidget extends StatefulWidget {
  final PurchaseModel purchase;
  const PurchaseEditWidget({super.key, required this.purchase});

  @override
  State<PurchaseEditWidget> createState() => _PurchaseEditWidgetState();
}

class _PurchaseEditWidgetState extends State<PurchaseEditWidget> {
  final ctr = Get.find<PurchaseController>();

  late TextEditingController poNoCtr;
  late TextEditingController qtyCtr;
  late TextEditingController priceCtr;

  DateTime? refDate;
  DateTime? expDeliveryDate;

  @override
  void initState() {
    super.initState();
    poNoCtr = TextEditingController(text: widget.purchase.invoiceNo);
    qtyCtr = TextEditingController(text: "1");
    priceCtr = TextEditingController(text: "0.00");

    refDate = widget.purchase.purchaseDate;
    expDeliveryDate = widget.purchase.expectedDelivery;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ctr.supplierCtr.getSuppliers();
      } catch (_) {}
      if (ctr.supplierCtr.suppliers.isNotEmpty) {
        try {
          final matchedSupplier = ctr.supplierCtr.suppliers.firstWhere(
            (s) => s.id == widget.purchase.supplierId || s.name == widget.purchase.supplierName,
          );
          ctr.selectedSupplier.value = matchedSupplier;
        } catch (e) {
          ctr.selectedSupplier.value = null;
        }
      }
    });
  }

  @override
  void dispose() {
    poNoCtr.dispose();
    qtyCtr.dispose();
    priceCtr.dispose();
    super.dispose();
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
        title: const Text(
          "Edit Purchase",
          style: TextStyle(color: Color(0xFF003B6D), fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(Icons.person, color: Colors.black),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit Purchase Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(height: 24),

              _buildLabel("Supplier Name"),
              Obx(() => DropdownButtonFormField<SupplierModel>(
                    value: ctr.supplierCtr.suppliers.contains(ctr.selectedSupplier.value) 
                        ? ctr.selectedSupplier.value 
                        : null,
                    decoration: _inputDecoration("Select a supplier"),
                    items: ctr.supplierDropdownItems,
                    onChanged: (val) {
                      ctr.selectedSupplier.value = val;
                    },
                  )),
              const SizedBox(height: 12),

              _buildLabel("# Reference / PO Number"),
              TextField(
                controller: poNoCtr,
                decoration: _inputDecoration("PO-2026-001"),
              ),
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
                            decoration: _inputDecoration("dd/mm/yyyy").copyWith(
                              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                            ),
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
                              initialDate: expDeliveryDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) setState(() => expDeliveryDate = picked);
                          },
                          child: InputDecorator(
                            decoration: _inputDecoration("dd/mm/yyyy").copyWith(
                              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                            ),
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
                  const Text("Purchase Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF003B6D))),
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
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
                              TextField(
                                controller: qtyCtr,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration("1"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Unit Price (\$)"),
                              TextField(
                                controller: priceCtr,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration("0.00"),
                              ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004B87),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (ctr.selectedSupplier.value == null) {
                      Get.snackbar("Error", "Please select supplier");
                      return;
                    }

                    final updated = PurchaseModel(
                      id: widget.purchase.id,
                      supplierId: ctr.selectedSupplier.value!.id ?? widget.purchase.supplierId,
                      supplierName: ctr.selectedSupplier.value!.name,
                      invoiceNo: poNoCtr.text,
                      totalAmount: widget.purchase.totalAmount,
                      purchaseDate: refDate ?? widget.purchase.purchaseDate,
                      expectedDelivery: expDeliveryDate,
                      status: widget.purchase.status,
                    );

                    await ctr.updatePurchase(updated);
                    Get.back();
                  },
                  child: const Text("Update Purchase", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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