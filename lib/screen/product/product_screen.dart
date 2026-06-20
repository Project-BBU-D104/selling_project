import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/screen/product/widget/add_product_widget.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final ctr = Get.find<ProductController>();
  final ctrCategory = Get.find<CategoryController>();
  final ctrBrand = Get.find<BrandController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product")),
      body: Column(
        children: [
          Expanded(child: Text("This is product")),
        ],
      ),

    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddProductWidget(
            categories: ctrCategory.category,
             brands: ctrBrand.brands,
          ),
        );
      },
      child: const Icon(Icons.add),
    ),
  );
  }
}