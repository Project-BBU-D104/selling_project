import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/product_controller.dart';
import '../../../../models/product_management/brand_model.dart';
import '../../../../models/product_management/category_model.dart';
import '../../../../models/product_management/product_model.dart';
import 'product_tokens.dart';

/// "Add New Product" form (HardwarePro design): header with back arrow
/// + logo, Product Name, Category, SKU, Price, Stock Level, Description,
/// sync status row, Discard / Save Product actions.
class ProductAddWidget extends StatelessWidget {
  final void Function(ProductModel)? onSaved;
  final List<CategoryModel>? categories;
  final List<BrandModel>? brands;

  ProductAddWidget({
    Key? key,
    this.onSaved,
    this.categories,
    this.brands,
  }) : super(key: key);

  final ProductController controller = Get.find<ProductController>();

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

    final product = ProductModel(
      name: controller.nameCtrl.text.trim(),
      costPrice: price,
      salePrice: price,
      quantity: stock,
      categoryId: categoryId,
      brandId: brandId,
      description: controller.descriptionCtrl.text.trim(),
    );

    await controller.addProduct(product);
    onSaved?.call(product);
    Get.back();
    Get.snackbar('Success', 'Product Saved');
    _clearForm();
  }

  void _clearForm() {
    controller.nameCtrl.clear();
    controller.priceCtrl.clear();
    controller.skuCtrl.clear();
    controller.stockCtrl.clear();
    controller.selectedCategoryId.value = null;
    controller.selectedCategoryName.value = null;
    controller.selectedBrandId.value = null;
    controller.selectedBrandName.value = null;
    controller.descriptionCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final categoryDropdownItems = (categories ?? []).map((category) {
      return DropdownMenuItem<String>(
        value: category.id,
        child: Text(category.name),
      );
    }).toList();

    return ProductFormShell(
      title: 'Add New Product',
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
      leftButtonLabel: 'Discard',
      onLeftButton: () {
        _clearForm();
        Get.back();
      },
      rightButtonLabel: 'Save Product',
      rightButtonIcon: Icons.save,
      onRightButton: () => _submit(context),
    );
  }
}

/// Shared shell used by both Add and Edit product forms so they stay
/// visually identical: header (back arrow + title + logo), scrollable
/// field list, sync status row, and two action buttons.
class ProductFormShell extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final String leftButtonLabel;
  final VoidCallback onLeftButton;
  final String rightButtonLabel;
  final IconData rightButtonIcon;
  final VoidCallback onRightButton;

  const ProductFormShell({
    Key? key,
    required this.title,
    required this.formKey,
    required this.fields,
    required this.leftButtonLabel,
    required this.onLeftButton,
    required this.rightButtonLabel,
    required this.rightButtonIcon,
    required this.onRightButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEDEFF3),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460, maxHeight: 760),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        children: [
          // Header: back arrow, title, logo mark
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: ProductTokens.navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Icon(Icons.build, size: 15, color: ProductTokens.navy),
              const SizedBox(width: 4),
              const Text(
                'HardwarePro',
                style: TextStyle(
                  color: ProductTokens.navy,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          ...fields,
          const SizedBox(height: 18),

          // Sync status row
          Row(
            children: const [
              Icon(Icons.circle, size: 8, color: ProductTokens.green),
              SizedBox(width: 6),
              Text(
                'System Operational: Ready for sync',
                style: TextStyle(color: ProductTokens.labelGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onLeftButton,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFD7DCE3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    leftButtonLabel,
                    style: const TextStyle(
                      color: ProductTokens.navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onRightButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProductTokens.navy,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(rightButtonIcon, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          rightButtonLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small static helpers reused for input decoration/labels by both
/// ProductAddWidget and ProductEditWidget.
class ProductFormField {
  static Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: ProductTokens.labelGrey,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  static InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ProductTokens.hintGrey),
      filled: true,
      fillColor: ProductTokens.fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
