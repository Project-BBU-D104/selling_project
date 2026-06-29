// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:selling_project/controller/product_controller.dart';
// import '../../../../models/product_management/brand_model.dart';
// import '../../../../models/product_management/category_model.dart';
// import '../../../../models/product_management/product_model.dart';
// import 'product_tokens.dart';

// /// "Edit Product" form — same layout as ProductAddWidget but pre-filled
// /// with an existing product's values, and updates instead of creating.
// class ProductEditWidget extends StatelessWidget {
//   final ProductModel product;
//   final void Function(ProductModel)? onSaved;
//   final List<CategoryModel>? categories;
//   final List<BrandModel>? brands;

//   ProductEditWidget({
//     Key? key,
//     required this.product,
//     this.onSaved,
//     this.categories,
//     this.brands,
//   }) : super(key: key);

//   final ProductController controller = Get.find<ProductController>();

//   void _prefill() {
//     controller.nameCtrl.text = product.name;
//     controller.priceCtrl.text = product.salePrice.toString();
//     controller.skuCtrl.text = product.sku ?? '';
//     controller.stockCtrl.text = product.quantity.toString();
//     controller.descriptionCtrl.text = product.description ?? '';
//     controller.selectedCategoryId.value = product.categoryId;
//     controller.selectedBrandId.value = product.brandId;
//   }

//   Future<void> _submit(BuildContext context) async {
//     if (!controller.formKey.currentState!.validate()) return;

//     final price = double.parse(controller.priceCtrl.text.trim());
//     final stock = int.tryParse(controller.stockCtrl.text.trim()) ?? 0;

//     product.name = controller.nameCtrl.text.trim();
//     product.costPrice = price;
//     product.salePrice = price;
//     product.quantity = stock;
//     product.categoryId = controller.selectedCategoryId.value!;
//     product.brandId = controller.selectedBrandId.value!;
//     product.description = controller.descriptionCtrl.text.trim();

//     final updated = product;

//     await controller.updateProduct(updated);
//     onSaved?.call(updated);
//     Get.back();
//     Get.snackbar('Success', 'Product Updated');
//   }

//   InputDecoration _decoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(color: ProductTokens.hintGrey),
//       filled: true,
//       fillColor: ProductTokens.fieldFill,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }

//   Widget _label(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: ProductTokens.labelGrey,
//           fontWeight: FontWeight.w600,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _prefill();

//     final categoryDropdownItems = (categories ?? []).map((category) {
//       return DropdownMenuItem<String>(
//         value: category.id,
//         child: Text(category.name),
//       );
//     }).toList();

//     return Form(
//       key: controller.formKey,
//       child: ListView(
//         padding: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 8,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         children: [
//           _label('Product Name'),
//           TextFormField(
//             controller: controller.nameCtrl,
//             decoration: _decoration('e.g. Industrial Drill Press'),
//             validator: (v) =>
//                 (v == null || v.trim().isEmpty) ? 'Enter product name' : null,
//           ),
//           const SizedBox(height: 16),

//           _label('Category'),
//           Obx(
//             () => DropdownButtonFormField<String>(
//               value: controller.selectedCategoryId.value,
//               decoration: _decoration('Select Category'),
//               isExpanded: true,
//               icon: const Icon(Icons.keyboard_arrow_down,
//                   color: ProductTokens.navy),
//               items: categoryDropdownItems,
//               onChanged: (value) {
//                 controller.selectedCategoryId.value = value;
//                 final category =
//                     categories?.firstWhere((c) => c.id == value);
//                 controller.selectedCategoryName.value = category?.name;
//               },
//               validator: (v) =>
//                   (v == null || v.isEmpty) ? 'Select category' : null,
//             ),
//           ),
//           const SizedBox(height: 16),

//           _label('SKU'),
//           TextFormField(
//             controller: controller.skuCtrl,
//             decoration: _decoration('HP-XXXX-XXXX'),
//             validator: (v) =>
//                 (v == null || v.trim().isEmpty) ? 'Enter SKU' : null,
//           ),
//           const SizedBox(height: 16),

//           _label('Price (USD)'),
//           TextFormField(
//             controller: controller.priceCtrl,
//             decoration: _decoration('0.00').copyWith(
//               prefixText: '\$ ',
//               prefixStyle: const TextStyle(color: ProductTokens.navy),
//             ),
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//             validator: (v) {
//               if (v == null || v.trim().isEmpty) return 'Enter price';
//               if (double.tryParse(v.trim()) == null) return 'Invalid number';
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),

//           _label('Stock Level'),
//           TextFormField(
//             controller: controller.stockCtrl,
//             decoration: _decoration('0'),
//             keyboardType: TextInputType.number,
//             validator: (v) {
//               if (v == null || v.trim().isEmpty) return 'Enter stock level';
//               if (int.tryParse(v.trim()) == null) return 'Invalid number';
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),

//           _label('Description'),
//           TextFormField(
//             controller: controller.descriptionCtrl,
//             decoration:
//                 _decoration('Enter product specifications and details...'),
//             maxLines: 4,
//           ),
//           const SizedBox(height: 18),

//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () => Get.back(),
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     side: const BorderSide(color: Color(0xFFD7DCE3)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                         color: ProductTokens.navy, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () => _submit(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ProductTokens.navy,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   icon: const Icon(Icons.save, size: 18, color: Colors.white),
//                   label: const Text(
//                     'Update Product',
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension ProductControllerUpdateExtensions on ProductController {
//   Future<void> updateProduct(ProductModel product) async {
//     final dynamic dynamicController = this;

//     try {
//       await dynamicController.updateProduct(product);
//       return;
//     } catch (_) {}

//     try {
//       await dynamicController.editProduct(product);
//       return;
//     } catch (_) {}

//     try {
//       await dynamicController.saveProduct(product);
//       return;
//     } catch (_) {}

//     throw UnsupportedError(
//       'ProductController does not expose a product update method.',
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/product_controller.dart';
import '../../../../models/product_management/brand_model.dart';
import '../../../../models/product_management/category_model.dart';
import '../../../../models/product_management/product_model.dart';
import 'product_add_widget.dart' show ProductFormShell, ProductFormField;
import 'product_tokens.dart';

/// "Edit Product" form — same visual shell as ProductAddWidget
/// (header, fields, status row, buttons), pre-filled with the
/// existing product's values, updates instead of creating.
class ProductEditWidget extends StatelessWidget {
  final ProductModel product;
  final void Function(ProductModel)? onSaved;
  final List<CategoryModel>? categories;
  final List<BrandModel>? brands;

  ProductEditWidget({
    Key? key,
    required this.product,
    this.onSaved,
    this.categories,
    this.brands,
  }) : super(key: key);

  final ProductController controller = Get.find<ProductController>();

  void _prefill() {
    controller.nameCtrl.text = product.name;
    controller.priceCtrl.text = product.salePrice.toString();
    controller.skuCtrl.text = product.sku ?? '';
    controller.stockCtrl.text = product.quantity.toString();
    controller.descriptionCtrl.text = product.description ?? '';
    controller.selectedCategoryId.value = product.categoryId;
    controller.selectedBrandId.value = product.brandId;
  }

  Future<void> _submit(BuildContext context) async {
    if (!controller.formKey.currentState!.validate()) return;

    final categoryId = controller.selectedCategoryId.value;
    if (categoryId == null || categoryId.isEmpty) {
      Get.snackbar('Missing Category', 'Please select a category');
      return;
    }
    final brandId = controller.selectedBrandId.value ?? '';

    final price = double.parse(controller.priceCtrl.text.trim());
    final stock = int.tryParse(controller.stockCtrl.text.trim()) ?? 0;

    // Mutate the existing model directly (matches your project's
    // ProductModel, which doesn't have copyWith).
    product.name = controller.nameCtrl.text.trim();
    product.costPrice = price;
    product.salePrice = price;
    product.quantity = stock;
    product.categoryId = categoryId;
    product.brandId = brandId;
    product.description = controller.descriptionCtrl.text.trim();

    await controller.updateProduct(product);
    onSaved?.call(product);
    Get.back();
    Get.snackbar('Success', 'Product Updated');
  }

  @override
  Widget build(BuildContext context) {
    _prefill();

    final categoryDropdownItems = (categories ?? []).map((category) {
      return DropdownMenuItem<String>(
        value: category.id,
        child: Text(category.name),
      );
    }).toList();

    return ProductFormShell(
      title: 'Edit Product',
      formKey: controller.formKey,
      fields: [
        ProductFormField.label('Product Name'),
        TextFormField(
          controller: controller.nameCtrl,
          decoration: ProductFormField.decoration('e.g. Industrial Drill Press'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter product name' : null,
        ),
        const SizedBox(height: 16),

        ProductFormField.label('Category'),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedCategoryId.value,
            decoration: ProductFormField.decoration('Select Category'),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: ProductTokens.navy),
            items: categoryDropdownItems,
            onChanged: (value) {
              controller.selectedCategoryId.value = value;
              final category = categories?.firstWhere((c) => c.id == value);
              controller.selectedCategoryName.value = category?.name;
            },
            validator: (v) => (v == null || v.isEmpty) ? 'Select category' : null,
          ),
        ),
        const SizedBox(height: 16),

        ProductFormField.label('SKU'),
        TextFormField(
          controller: controller.skuCtrl,
          decoration: ProductFormField.decoration('HP-XXXX-XXXX'),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter SKU' : null,
        ),
        const SizedBox(height: 16),

        ProductFormField.label('Price (USD)'),
        TextFormField(
          controller: controller.priceCtrl,
          decoration: ProductFormField.decoration('0.00').copyWith(
            prefixText: '\$ ',
            prefixStyle: const TextStyle(color: ProductTokens.navy),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter price';
            if (double.tryParse(v.trim()) == null) return 'Invalid number';
            return null;
          },
        ),
        const SizedBox(height: 16),

        ProductFormField.label('Stock Level'),
        TextFormField(
          controller: controller.stockCtrl,
          decoration: ProductFormField.decoration('0'),
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter stock level';
            if (int.tryParse(v.trim()) == null) return 'Invalid number';
            return null;
          },
        ),
        const SizedBox(height: 16),

        ProductFormField.label('Description'),
        TextFormField(
          controller: controller.descriptionCtrl,
          decoration:
              ProductFormField.decoration('Enter product specifications and details...'),
          maxLines: 4,
        ),
      ],
      leftButtonLabel: 'Cancel',
      onLeftButton: () => Get.back(),
      rightButtonLabel: 'Update Product',
      rightButtonIcon: Icons.save,
      onRightButton: () => _submit(context),
    );
  }
}
