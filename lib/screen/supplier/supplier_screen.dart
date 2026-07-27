import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/supplier_controller.dart';
import 'package:selling_project/models/supplier_model.dart';
import 'widget/supplier_add_widget.dart';
import 'widget/supplier_detail_widget.dart';
import 'widget/supplier_edit_widget.dart';

class SupplierScreen extends StatelessWidget {
  SupplierScreen({super.key});

  final ctr = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003865)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Supplier Management',
          style: TextStyle(
            color: Color(0xFF003865),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              final total = ctr.suppliers.length;
              final active =
                  ctr.suppliers.where((s) => s.status == true).length;
              final inactive = total - active;

              return Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 115,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003865),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL SUPPLIERS',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '$total',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 115,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Active',
                                      style: TextStyle(
                                          color: Color(0xFF4B5563),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  Text('$active',
                                      style: const TextStyle(
                                          color: Color(0xFF003865),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Inactive',
                                      style: TextStyle(
                                          color: Color(0xFF4B5563),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  Text('$inactive',
                                      style: const TextStyle(
                                          color: Color(0xFF003865),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'Supplier Directory',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (ctr.loading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (ctr.suppliers.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("No suppliers registered yet."),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ctr.suppliers.length,
                itemBuilder: (context, index) {
                  final SupplierModel supplier = ctr.suppliers[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => SupplierDetailWidget(supplier: supplier));
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFF003865)
                                      .withValues(alpha: 0.1),
                                  child: Text(
                                    supplier.name.isNotEmpty
                                        ? supplier.name
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : 'S',
                                    style: const TextStyle(
                                      color: Color(0xFF003865),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        supplier.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      if (supplier.companyName != null &&
                                          supplier.companyName!.isNotEmpty)
                                        Text(
                                          supplier.companyName!,
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: supplier.status
                                              ? const Color(0xFFDCFCE7)
                                              : const Color(0xFFFFE4E6),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          supplier.status
                                              ? 'Active'
                                              : 'Inactive',
                                          style: TextStyle(
                                            color: supplier.status
                                                ? const Color(0xFF15803D)
                                                : const Color(0xFF9F1239),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors.grey),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      ctr.populateForm(supplier);
                                      Get.to(() => const SupplierEdit(),
                                          arguments: supplier);
                                    } else if (value == 'delete') {
                                      if (supplier.id != null) {
                                        ctr.deleteSupplier(supplier.id!);
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined,
                                              size: 18, color: Colors.grey),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline,
                                              size: 18,
                                              color: Colors.redAccent),
                                          SizedBox(width: 8),
                                          Text('Delete',
                                              style: TextStyle(
                                                  color: Colors.redAccent)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  supplier.phone,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.mail_outline,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  supplier.email,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const SupplierAdd()),
        backgroundColor: const Color(0xFF003865),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}