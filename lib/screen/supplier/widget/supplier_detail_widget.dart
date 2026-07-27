import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/models/supplier_model.dart';

class SupplierDetailWidget extends StatelessWidget {
  final SupplierModel supplier;

  const SupplierDetailWidget({super.key, required this.supplier});

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
          'Supplier Details',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor:
                        const Color(0xFF003865).withValues(alpha: 0.1),
                    child: Text(
                      supplier.name.isNotEmpty
                          ? supplier.name.substring(0, 1).toUpperCase()
                          : 'S',
                      style: const TextStyle(
                        color: Color(0xFF003865),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    supplier.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  if (supplier.companyName != null &&
                      supplier.companyName!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      supplier.companyName!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: supplier.status
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFFE4E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: supplier.status
                              ? const Color(0xFF15803D)
                              : const Color(0xFF9F1239),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          supplier.status ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: supplier.status
                                ? const Color(0xFF15803D)
                                : const Color(0xFF9F1239),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.person_outline,
                    'Contact Person',
                    supplier.contactPerson,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    Icons.phone_outlined,
                    'Phone Number',
                    supplier.phone,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    Icons.email_outlined,
                    'Email Address',
                    supplier.email,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    Icons.location_on_outlined,
                    'Address',
                    supplier.address,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF003865).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF003865)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                (value != null && value.isNotEmpty) ? value : 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}