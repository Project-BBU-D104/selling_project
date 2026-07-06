import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/brand_controller.dart';
import 'package:selling_project/screen/brand/widget/brand_card_widget.dart';
import 'package:selling_project/screen/brand/widget/brand_add_widget.dart';
import 'package:selling_project/screen/brand/widget/brand_edit_widget.dart';

class BrandScreen extends StatelessWidget {
  BrandScreen({super.key});

  final BrandController ctr = Get.find<BrandController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brand"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            BrandAddWidget(),
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

              if (ctr.brands.isEmpty) {
                return const Center(child: Text("No brands found."));
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final currentBrand = ctr.brands[index];

                        void openEditSheet() {
                          Get.bottomSheet(
                            BrandEditWidget(brand: currentBrand),
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                          );
                        }

                        return BrandCardWidget(
                          brand: currentBrand,
                          onTap: openEditSheet,
                          onEdit: openEditSheet,
                          onDelete: () {
                            Get.defaultDialog(
                              title: "Delete Brand",
                              middleText: "Are you sure you want to delete ${currentBrand.name}?",
                              textConfirm: "Delete",
                              textCancel: "Cancel",
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                ctr.deleteBrand(currentBrand.id!);
                                Get.back();
                              },
                            );
                          },
                        );
                      },
                      childCount: ctr.brands.length,
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