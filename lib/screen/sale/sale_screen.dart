import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'sale_detail_screen.dart';

class SaleScreen extends StatelessWidget {
  SaleScreen({super.key});

  final SaleController ctr =
      Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales"),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: ctr.createSale, child: Text("Save Sale")),
        ],
      ),
    );
  }
}