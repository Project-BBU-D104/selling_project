import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/customer_controller.dart';

class CustomerSearch extends StatelessWidget {
  final Function(String) onChanged;
  const CustomerSearch({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomerController>();

    return TextField(
      controller: ctr.searchTxtController,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: 'Search by name, phone, or email...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: ctr.searchTxtController,
              builder: (context, value, child) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                  onPressed: () {
                    ctr.searchTxtController.clear();
                    onChanged('');
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.tune, color: Color(0xFF4B5563), size: 18),
                  tooltip: 'Filter Status',
                  offset: const Offset(0, 40),
                  onSelected: (String statusFilter) {
                    ctr.filterByStatus(statusFilter);
                  },
                  itemBuilder: (BuildContext context) {
                    List<String> statusOptions = ['All', 'Active', 'Inactive'];

                    return statusOptions.map((String status) {
                      return PopupMenuItem<String>(
                        value: status,
                        child: Row(
                          children: [
                            if (status == 'Active')
                              const Icon(Icons.circle, size: 8, color: Colors.green)
                            else if (status == 'Inactive')
                              const Icon(Icons.circle, size: 8, color: Colors.red)
                            else
                              const Icon(Icons.apps, size: 14, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              status,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005293), width: 1.5),
        ),
      ),
    );
  }
}