import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/models/product_management/category_model.dart';

class CategoryEditWidget extends StatelessWidget {
  final CategoryModel category;
  CategoryEditWidget({super.key, required this.category});

  final ctr = Get.find<CategoryController>();
  final formKey = GlobalKey<FormState>();

  late final nameController = TextEditingController(text: category.name);
  late final descController = TextEditingController(text: category.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name', border: OutlineInputBorder()),
              validator: (val) => val == null || val.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            // UPDATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    CategoryModel updated = CategoryModel(
                      id: category.id,
                      name: nameController.text.trim(),
                      description: descController.text.trim(),
                      status: category.status,
                      createdAt: category.createdAt,
                      updatedAt: DateTime.now(),
                    );
                    await ctr.updateCategory(updated);
                    Get.back();
                  }
                },
                child: const Text("Update Category"),
              ),
            ),
            const SizedBox(height: 10),
            // CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}