// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:selling_project/controller/brand_controller.dart';
// // import 'package:selling_project/controller/category_controller.dart';
// // import 'package:selling_project/controller/product_controller.dart';
// // import 'package:selling_project/screen/product/widget/add_product_widget.dart';

// // class ProductScreen extends StatelessWidget {
// //   ProductScreen({super.key});

// //   final ctr = Get.find<ProductController>();
// //   final ctrCategory = Get.find<CategoryController>();
// //   final ctrBrand = Get.find<BrandController>();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Product")),
// //       body: Column(
// //         children: [
// //           Expanded(child: Text("This is product")),
// //         ],
// //       ),

// //     floatingActionButton: FloatingActionButton(
// //       onPressed: () {
// //         showModalBottomSheet(
// //           context: context,
// //           isScrollControlled: true,
// //           builder: (_) => AddProductWidget(
// //             categories: ctrCategory.category,
// //              brands: ctrBrand.brands,
// //           ),
// //         );
// //       },
// //       child: const Icon(Icons.add),
// //     ),
// //   );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/screen/product/widget/product_add_widget.dart';
import 'package:selling_project/screen/product/widget/product_card_widget.dart';
import 'package:selling_project/screen/product/widget/product_edit_widget.dart';
import 'package:selling_project/screen/product/widget/product_search_widget.dart';
import 'package:selling_project/screen/product/widget/product_summary_widget.dart';





class ProductScreen extends StatelessWidget {
  ProductScreen({Key? key}) : super(key: key);

  final ProductController controller = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final BrandController brandController = Get.find<BrandController>();

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ProductAddWidget(
          categories: categoryController.category,
          brands: brandController.brands,
        ),
      ),
    );
  }

  void _openEditSheet(BuildContext context, product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ProductEditWidget(
          product: product,
          categories: categoryController.category,
          brands: brandController.brands,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ProductSummaryWidget(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProductSearchWidget(),
                  const SizedBox(height: 12),
                  const ProductFilterChips(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openAddSheet(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF13294B),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon:
                              const Icon(Icons.add, color: Colors.white, size: 18),
                          label: const Text(
                            'Add New',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE3E6EA)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.tune,
                            color: Color(0xFF13294B), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: controller.product.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final product = controller.product[index];
                    return ProductCardWidget(
                      product: product,
                      onEdit: () => _openEditSheet(context, product),
                      onDelete: () => controller.deleteProduct(product.id ?? ''),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
