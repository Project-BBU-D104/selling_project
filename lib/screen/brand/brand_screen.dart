import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';

class BrandScreen extends StatelessWidget {
  BrandScreen({super.key});

  final BrandController ctr = Get.find<BrandController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brand"),
      ),

      body: const Center(
        child: Text("This is brand"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          await ctr.addTestBrand();

          Get.snackbar(
            "Success",
            "Brand Added",
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}