import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/controller/purchase_controller.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';

class PurchaseEditWidget extends StatefulWidget {
  final PurchaseModel purchase;
  const PurchaseEditWidget({super.key, required this.purchase});

  @override
  State<PurchaseEditWidget> createState() => _PurchaseEditWidgetState();
}

class _PurchaseEditWidgetState extends State<PurchaseEditWidget> {
  final ctr = Get.find<PurchaseController>();

  late TextEditingController poNoCtr;
  late TextEditingController productNameCtr;
  late TextEditingController qtyCtr;
  late TextEditingController priceCtr;

  String? selectedSupplier;
  DateTime? refDate;
  DateTime? expDeliveryDate;

  @override
  void initState() {
    super.initState();
    poNoCtr = TextEditingController(text: widget.purchase.invoiceNo);
    productNameCtr = TextEditingController();
    qtyCtr = TextEditingController(text: "0");
    priceCtr = TextEditingController(text: "0.00");

    selectedSupplier = widget.purchase.supplierName;
    refDate = widget.purchase.purchaseDate;
    expDeliveryDate = widget.purchase.expectedDelivery;
  }

  @override
  void dispose() {
    poNoCtr.dispose();
    productNameCtr.dispose();
    qtyCtr.dispose();
    priceCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get dynamic suppliers list from supplierController
    List<String> suppliers = ctr.supplierCtr.suppliers
        .map((s) => s.name ?? "")
        .where((name) => name.isNotEmpty)
        .toList();

    // Fallback: Default list if supplier controller list is empty
    if (suppliers.isEmpty) {
      suppliers = [
        "Global Hardware Inc.",
        "Silicon Dynamics Co.",
        "Power Grid Solutions",
        "Apex Logistics Parts",
      ];
    }

    // 2. Ensure current selectedSupplier exists in the list to prevent Assertion Errors
    if (selectedSupplier != null && !suppliers.contains(selectedSupplier)) {
      suppliers.add(selectedSupplier!);
    }

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
              DropdownButtonFormField<String>(
                value: selectedSupplier,
                decoration: _inputDecoration("Select a supplier"),
                items: suppliers
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedSupplier = val),
              ),
              const SizedBox(height: 12),

              _buildLabel("# Reference / PO Number"),
              TextField(
                controller: poNoCtr,
                decoration: _inputDecoration("PO-2023-001"),
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

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Purchase Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF003B6D))),
                  Row(
                    children: [
                      Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF003B6D)),
                      SizedBox(width: 4),
                      Text("Add Item", style: TextStyle(color: Color(0xFF003B6D), fontWeight: FontWeight.bold)),
                    ],
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
                    _buildLabel("Product Name"),
                    TextField(
                      controller: productNameCtr,
                      decoration: _inputDecoration("e.g M12 Grade 8 Bolts"),
                    ),
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
                                decoration: _inputDecoration("0"),
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
                    final updated = PurchaseModel(
                      id: widget.purchase.id,
                      supplierId: widget.purchase.supplierId,
                      supplierName: selectedSupplier,
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