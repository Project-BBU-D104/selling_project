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
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: 'Search by name, phone, or ID...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.tune, color: Color(0xFF4B5563), size: 18),
              tooltip: 'Filter Categories',
              offset: const Offset(0, 40),
              onSelected: (String category) {
                ctr.selectSingleFilter(category);
              },
              itemBuilder: (BuildContext context) {
                List<String> categories = ['All', 'Standard', 'VIP', 'Wholesale', 'Internal']; 

                return categories.map((String category) {
                  return PopupMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
                    ),
                  );
                }).toList();
              },
            ),
          ),
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
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
      ),
    );
  }
}