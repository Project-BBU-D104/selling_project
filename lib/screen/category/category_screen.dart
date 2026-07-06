import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/category_controller.dart';
import 'package:selling_project/screen/category/widget/category_card_widget.dart';
import 'package:selling_project/screen/category/widget/category_add_widget.dart';
import 'package:selling_project/screen/category/widget/category_edit_widget.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final ctr = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            CategoryAddWidget(),
            backgroundColor: Colors.white,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (ctr.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (ctr.category.isEmpty) {
                return const Center(child: Text("No categories found."));
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final currentCategory = ctr.category[index];
                        void openEditSheet() {
                          Get.bottomSheet(
                            CategoryEditWidget(category: currentCategory),
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                          );
                        }

                        return CategoryCardWidget(
                          category: currentCategory,
                          onTap: openEditSheet,
                          onEdit: openEditSheet,
                          onDelete: () {
                            Get.defaultDialog(
                              title: "Delete Category",
                              middleText: "Are you sure you want to delete ${currentCategory.name}?",
                              textConfirm: "Delete",
                              textCancel: "Cancel",
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                ctr.deleteCategory(currentCategory.id!);
                                Get.back();
                              },
                            );
                          },
                        );
                      },
                      childCount: ctr.category.length,
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}