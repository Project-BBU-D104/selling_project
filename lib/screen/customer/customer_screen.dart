import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/customer_controller.dart';
import 'package:selling_project/screen/customer/widget/customer_add_widget.dart';
import 'package:selling_project/screen/customer/widget/customer_card_widget.dart';
import 'package:selling_project/screen/customer/widget/customer_summary_widget.dart';
import 'package:selling_project/screen/home/widget/drawer_widget.dart';

class CustomerScreen extends StatelessWidget {
  CustomerScreen({super.key});

  final ctr = Get.find<CustomerController>();
  final TextEditingController searchTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003366)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Customer Management',
          style: TextStyle(
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (ctr.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Management',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your high-value accounts.',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchTxtController,
                onChanged: (val) => ctr.searchCustomer(val),
                style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
                decoration: InputDecoration(
                  hintText: 'Search by name, phone, or ID...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.grey, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.tune,
                            color: Color(0xFF4B5563), size: 18),
                        tooltip: 'Filter Categories',
                        offset: const Offset(0, 40),
                        onSelected: (String category) {
                          ctr.selectSingleFilter(category);
                        },
                        itemBuilder: (BuildContext context) {
                          List<String> categories = [
                            'All',
                            'Standard',
                            'VIP',
                            'Wholesale',
                            'Internal'
                          ];
                          return categories.map((String category) {
                            return PopupMenuItem<String>(
                              value: category,
                              child: Text(category,
                                  style: const TextStyle(fontSize: 14)),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                ),
              ),
              const SizedBox(height: 16),
              CustomerSummaryWidget(totalCustomers: ctr.customers.length),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Directory',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                  ),
                  TextButton(
                    onPressed: () {
                      searchTxtController.clear();
                      ctr.selectSingleFilter('All');
                    },
                    child: const Text('View All',
                        style: TextStyle(
                            color: Color(0xFF0066B2),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (ctr.filteredCustomers.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Text("No Customers Found",
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ctr.filteredCustomers.length,
                  itemBuilder: (context, index) {
                    return CustomerCard(customer: ctr.filteredCustomers[index]);
                  },
                ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF003366),
        onPressed: () {
          ctr.clearForm();
          Get.to(() => const CustomerAddWidget());
        },
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
    );
  }
}
