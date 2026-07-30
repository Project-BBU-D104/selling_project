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
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Search by name, phone, or ID...',
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Colors.black87, size: 22),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF005288), width: 1.5),
        ),
      ),
    );
  }
}