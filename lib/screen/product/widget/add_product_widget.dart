import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/product_controller.dart';
import 'package:selling_project/models/product_management/brand_model.dart';
import 'package:selling_project/models/product_management/category_model.dart';
import '../../../models/product_management/product_model.dart';

class AddProductWidget extends StatelessWidget {
  final void Function(ProductModel)? onSaved;

  final List<CategoryModel>? categories;
  final List<BrandModel>? brands;

  final String? initialCategoryId;
  final String? initialCategoryName;

  final String? initialBrandId;
  final String? initialBrandName;

  AddProductWidget({
    Key? key,
    this.onSaved,
    this.categories,
    this.brands,
    this.initialCategoryId,
    this.initialCategoryName,
    this.initialBrandId,
    this.initialBrandName,
  }) : super(key: key);

  final ProductController controller =
      Get.find<ProductController>();

  Future<void> _submit(BuildContext context) async {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }

    final product = ProductModel(
      name: controller.nameCtrl.text.trim(),
      costPrice: double.parse(
        controller.priceCtrl.text.trim(),
      ),
      salePrice: double.parse(
        controller.priceCtrl.text.trim(),
      ),
      quantity: 0,
      categoryId:
          controller.selectedCategoryId.value!,
      brandId:
          controller.selectedBrandId.value!,
      description: controller.descriptionCtrl.text.trim(),

    );

    // print(product.toJson());

    await controller.addProduct(product);

    onSaved?.call(product);

    Get.back();

    Get.snackbar(
      "Success",
      "Product Saved",
    );

    controller.nameCtrl.clear();
    controller.priceCtrl.clear();

    controller.selectedCategoryId.value = null;
    controller.selectedCategoryName.value = null;

    controller.selectedBrandId.value = null;
    controller.selectedBrandName.value = null;

    controller.descriptionCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.selectedCategoryId.value == null) {
      controller.selectedCategoryId.value =
          initialCategoryId;
    }

    if (controller.selectedCategoryName.value == null) {
      controller.selectedCategoryName.value =
          initialCategoryName;
    }

    if (controller.selectedBrandId.value == null) {
      controller.selectedBrandId.value =
          initialBrandId;
    }

    if (controller.selectedBrandName.value == null) {
      controller.selectedBrandName.value =
          initialBrandName;
    }

    final categoryDropdownItems =
        (categories ?? []).map((category) {
      return DropdownMenuItem<String>(
        value: category.id,
        child: Text(category.name),
      );
    }).toList();

    final brandDropdownItems =
        (brands ?? []).map((brand) {
      return DropdownMenuItem<String>(
        value: brand.id,
        child: Text(brand.name),
      );
    }).toList();

    return Form(
      key: controller.formKey,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom:
              MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [

            // Product Name
            TextFormField(
              controller: controller.nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Product Name',
              ),
              validator: (v) {
                if (v == null ||
                    v.trim().isEmpty) {
                  return 'Enter product name';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // Price
            TextFormField(
              controller: controller.priceCtrl,
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null ||
                    v.trim().isEmpty) {
                  return 'Enter price';
                }

                if (double.tryParse(
                      v.trim(),
                    ) ==
                    null) {
                  return 'Invalid number';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            // Category Dropdown
            Obx(
              () => DropdownButtonFormField<String>(
                value:
                    controller
                        .selectedCategoryId
                        .value,
                decoration:
                    const InputDecoration(
                  labelText: 'Category',
                ),
                isExpanded: true,
                items:
                    categoryDropdownItems,
                onChanged: (value) {
                  controller
                      .selectedCategoryId
                      .value = value;

                  final category =
                      categories
                          ?.firstWhere(
                    (c) =>
                        c.id == value,
                  );

                  controller
                          .selectedCategoryName
                          .value =
                      category?.name;
                },
                validator: (v) {
                  if (v == null ||
                      v.isEmpty) {
                    return 'Select category';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 12),

            // Brand Dropdown
            Obx(
              () => DropdownButtonFormField<String>(
                value:
                    controller
                        .selectedBrandId
                        .value,
                decoration:
                    const InputDecoration(
                  labelText: 'Brand',
                ),
                isExpanded: true,
                items:
                    brandDropdownItems,
                onChanged: (value) {
                  controller
                      .selectedBrandId
                      .value = value;

                  final brand =
                      brands
                          ?.firstWhere(
                    (b) =>
                        b.id == value,
                  );

                  controller
                          .selectedBrandName
                          .value =
                      brand?.name;
                },
                validator: (v) {
                  if (v == null ||
                      v.isEmpty) {
                    return 'Select brand';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: controller.descriptionCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () =>
                  _submit(context),
              child: const Text(
                'Save Product',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
