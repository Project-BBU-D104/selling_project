import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/category_controller.dart' show CategoryController;

class CategoryScreen extends StatelessWidget {
    CategoryScreen({super.key});

  final ctr = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
            
              if (ctr.loading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final categorys = ctr.category[index];
                        return Card(
                          child: ListTile(
                            title: Text(categorys.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(categorys.description),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // ctr.deleteCustomer(
                                //   customer.id!
                                // );
                              },
                            ),
                          ),
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