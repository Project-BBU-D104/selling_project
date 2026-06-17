import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/customer_controller.dart'; 


class CustomerScreen extends StatelessWidget {

  CustomerScreen({super.key});


  final ctr = Get.find<CustomerController>();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
      ),
      body: Obx((){
        if(ctr.loading.value){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: ctr.customers.length,
          itemBuilder: (context,index){
            final customer = ctr.customers[index];
            return Card(
              child: ListTile(
                title: Text(customer.name),
                subtitle: Column(
                  crossAxisAlignment:
                    CrossAxisAlignment.start,
                  children: [
                    Text(customer.phone),
                    Text(customer.email),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    ctr.deleteCustomer(
                      customer.id!
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(

        child: Icon(Icons.add),

        onPressed: (){

          ctr.addCustomer();

        },

      ),

    );

  }

}