import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';
import 'package:selling_project/screen/sale/widget/customer_dropdown_widget.dart';

class SaleScreen extends StatelessWidget {
  SaleScreen({super.key});

  final SaleController ctr = Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Sale Order"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ព័ត៌មានការលក់ថ្មី",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // 🎯 បញ្ចូល Dropdown ជ្រើសរើសអតិថិជននៅទីនេះ
            CustomerDropdownWidget(), 
            
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            
            // បង្ហាញបញ្ជីទំនិញសាកល្បង (ទម្រង់សន្មតសិន)
            const ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.blue),
              title: Text("ទំនិញសាកល្បងក្នុងកន្ត្រក (Test Items)"),
              subtitle: Text("iPhone x2, Mouse x3, Keyboard x1"),
              trailing: Text("\$1050.00", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ),
            
            const Spacer(),
            
            // ប៊ូតុងរក្សាទុកការលក់
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: ctr.loading.value ? null : ctr.createSale,
                icon: ctr.loading.value 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.check_circle),
                label: Text(ctr.loading.value ? "កំពុងរក្សាទុក..." : "Process & Save Order"),
              ),
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}