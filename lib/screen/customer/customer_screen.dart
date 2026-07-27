import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/customer_controller.dart';
import 'package:selling_project/screen/customer/widget/customer_add_widget.dart';
import 'package:selling_project/screen/customer/widget/customer_card_widget.dart';
import 'package:selling_project/screen/customer/widget/customer_search_widget.dart';
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
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (ctr.loading.value && ctr.customers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF003366)),
          );
        }

        return Padding(
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
                          'Customer Directory',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your registered client accounts.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomerSearch(
                onChanged: (val) => ctr.searchCustomer(val),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        'Total Customers (${ctr.filteredCustomers.length})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      )),
                  TextButton(
                    onPressed: () {
                      ctr.searchController.clear();
                      ctr.searchCustomer('');
                      ctr.filterByStatus('All');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF0066B2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ctr.filteredCustomers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 56,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No Customers Found",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: ctr.filteredCustomers.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CustomerCard(
                            customer: ctr.filteredCustomers[index],
                          );
                        },
                      ),
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