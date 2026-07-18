import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/sale_controller.dart';

class SaleScreen extends StatelessWidget {
  SaleScreen({super.key});

  final SaleController ctr = Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "POS",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004C87)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          Column(
            children: [
              const Expanded(
                child: Center(
                  child: Text("Product Grid List View Here"),
                ),
              ),
              const SizedBox(height: 100), 
            ],
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: InkWell(
              onTap: () async {
                await ctr.loadCustomer("UNqPzjSqpMTWTcUs1jLN");
                ctr.loadSaleItems("INV002");
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A86B),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00A86B).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "3",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Order",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "3 Items",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      "\$45.00",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF00A86B),
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}