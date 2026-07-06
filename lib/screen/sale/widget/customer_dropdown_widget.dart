import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/customer_controller.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'package:selling_project/models/customer_model.dart';

class CustomerDropdownWidget extends StatelessWidget {
  CustomerDropdownWidget({super.key});

  final saleCtr = Get.find<SaleController>();
  // ហៅ CustomerController ដើម្បីទាញយកបញ្ជីអតិថិជនដែលមានស្រាប់
  final customerCtr = Get.put(CustomerController()); 

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (customerCtr.customers.isEmpty) {
        return const Text("កំពុងទាញយកទិន្នន័យអតិថិជន ឬមិនមានទិន្នន័យ...");
      }

      return DropdownButtonFormField<CustomerModel>(
        decoration: const InputDecoration(
          labelText: "ជ្រើសរើសអតិថិជន (Select Customer)",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person),
        ),
        value: saleCtr.selectedCustomer.value,
        hint: const Text("សូមជ្រើសរើសអតិថិជន"),
        items: customerCtr.customers.map((CustomerModel customer) {
          return DropdownMenuItem<CustomerModel>(
            value: customer,
            child: Text("${customer.customerName} (${customer.phone})"),
          );
        }).toList(),
        onChanged: (CustomerModel? newValue) {
          saleCtr.selectedCustomer.value = newValue;
        },
      );
    });
  }
}