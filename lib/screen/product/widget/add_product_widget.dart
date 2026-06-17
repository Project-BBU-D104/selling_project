import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/product_controller.dart';
import '../../../models/product_model.dart';

class AddProductWidget extends StatelessWidget {
  final void Function(ProductModel)? onSaved;
  final List<dynamic>? categories;
  final String? initialCategoryId;
  final String? initialCategoryName;

  AddProductWidget({
    Key? key,
    this.onSaved,
    this.categories,
    this.initialCategoryId,
    this.initialCategoryName,
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
      category: {
        "id": controller.selectedCategoryId.value,
        "name": controller.selectedCategoryName.value,
      },
    );

    print(product.toJson());

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

    final dropdownItems =
        <DropdownMenuItem<String>>[];

    for (final category in (categories ?? [])) {
      String? id;
      String name = '';

      if (category is Map) {
        id = category['id']?.toString();
        name = category['name']?.toString() ?? '';
      } else {
        try {
          id = category.id?.toString();
          name = category.name?.toString() ?? '';
        } catch (_) {}
      }

      if (id != null) {
        dropdownItems.add(
          DropdownMenuItem<String>(
            value: id,
            child: Text(name),
          ),
        );
      }
    }

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: controller.nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Enter name';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

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
              if (v == null || v.trim().isEmpty) {
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

          const SizedBox(height: 8),

          Obx(
            () => DropdownButtonFormField<String>(
              value:
                  controller.selectedCategoryId.value,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              isExpanded: true,
              hint: const Text(
                'Select category',
              ),
              items: dropdownItems,
              onChanged: (value) {
                final category =
                    (categories ?? []).firstWhere(
                  (e) {
                    if (e is Map) {
                      return e['id'].toString() ==
                          value;
                    }

                    return e.id.toString() ==
                        value;
                  },
                );

                controller
                    .selectedCategoryId.value = value;

                if (category is Map) {
                  controller
                          .selectedCategoryName.value =
                      category['name']
                          .toString();
                } else {
                  controller
                          .selectedCategoryName.value =
                      category.name.toString();
                }
              },
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Select category';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => _submit(context),
            child: const Text(
              'Save Product',
            ),
          ),
        ],
      ),
    );
  }
}