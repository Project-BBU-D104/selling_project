import 'package:flutter/material.dart';
import 'package:selling_project/models/customer_model.dart';

class CustomerHeaderWidget extends StatelessWidget {
  final CustomerModel? customer;

  const CustomerHeaderWidget({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    if (customer == null) {
      return Card(
        margin: const EdgeInsets.all(12),
        color: Colors.red[50],
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.warning, color: Colors.white),
          ),
          title: Text(
            "មិនមានព័ត៌មានអតិថិជនឡើយ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
          ),
          subtitle: Text("អតិថិជនទូទៅ (Walk-in Customer)"),
        ),
      );
    }
    return Card(
      margin: const EdgeInsets.all(12),
      color: Colors.blue[50],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          customer!.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          customer!.phone,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }
}