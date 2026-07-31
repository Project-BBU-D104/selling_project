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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text(
          'Customer',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 30),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (ctr.loading.value && ctr.customers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF005288)),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CustomerSearch(
                onChanged: (val) => ctr.searchCustomer(val),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        '${ctr.filteredCustomers.length} Customers',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      ctr.clearForm();
                      Get.to(() => const CustomerAddWidget());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005288),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      'Add Customer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
    );
  }
}