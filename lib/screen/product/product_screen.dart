import 'package:flutter/material.dart';
import 'package:selling_project/screen/product/widget/add_product_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product")),
      body: Text("This is product"),

      floatingActionButton: FloatingActionButton(onPressed: () {
        showModalBottomSheet(context: context, builder: (context) => AddProductWidget());
      }),
    );
  }
}