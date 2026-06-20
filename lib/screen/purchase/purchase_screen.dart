import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/purchase_controller.dart';
import 'package:selling_project/models/purchase/purchase_items_model.dart';
import 'package:selling_project/models/purchase/purchase_model.dart';

class PurchaseScreen extends StatelessWidget {
  PurchaseScreen({super.key});

  final PurchaseController ctr = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase"),
      ),

      body: const Center(
        child: Text("This is purchase"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ctr.addTestPurchase();
            Get.snackbar(
              "Success",
              "Purchase + Purchase Item Added",
            );
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}