import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/supplier_controller.dart';

class SupplierScreen extends StatelessWidget {
  SupplierScreen({super.key});
  
  final ctr = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplier")
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx((){
              if(ctr.loading.value){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: ctr.suppliers.length,
                itemBuilder: (context,index){
                  final supplier = ctr.suppliers[index];
                  return Card(
                    child: ListTile(
                      title: Text(supplier.name),
                      subtitle: Column(
                        crossAxisAlignment:
                          CrossAxisAlignment.start,
                        children: [
                          Text(supplier.phone),
                          Text(supplier.email),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          // ctr.deleteCustomer(
                          //   customer.id!
                          // );
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}