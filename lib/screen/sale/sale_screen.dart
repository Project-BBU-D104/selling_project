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
          // ផ្នែកខាងលើ៖ បញ្ជីផលិតផល (កូដចាស់របស់អ្នក)
          Column(
            children: [
              /* អ្នកអាចដាក់ Search Bar, Categories tabs 
                និង GridView បង្ហាញផលិតផលរបស់អ្នកនៅត្រង់នេះ...
              */
              const Expanded(
                child: Center(
                  child: Text("Product Grid List View Here"),
                ),
              ),
              
              // បន្ថែម Space នៅខាងក្រោមដើម្បីកុំឱ្យផលិតផលបាំងជាមួយ Bottom Bar
              const SizedBox(height: 100), 
            ],
          ),

          // ផ្នែកខាងក្រោម៖ Floating Order Review Bar (តាមរូបភាពទី១ និងទី២)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: InkWell(
              onTap: () async {
                // នៅពេលចុច៖ វានឹងដំណើរការរត់ទៅកាន់ផ្ទាំង Review Order (រូបភាពទី៣)
                // ឧទាហរណ៍៖ ចាប់យកទិន្នន័យ customer និង items រួចរត់ទៅផ្ទាំងបន្ទាប់
                await ctr.loadCustomer("UNqPzjSqpMTWTcUs1jLN");
                ctr.loadSaleItems("INV002"); 
                
                // ប្តូរទៅកាន់ Route ឬ Screen Detail (Review Order) របស់អ្នក
                // Get.toNamed(AppRoute.saleDetail);
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A86B), // ពណ៌បៃតងស្អាតដូចក្នុងរូបភាពទី២
                  borderRadius: BorderRadius.circular(35), // ធ្វើឱ្យរាងមូលទ្រវែង
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
                    // Icon កន្ត្រកទិញអីវ៉ាន់ និងរង្វង់លេខសម្គាល់ចំនួនទំនិញ
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
                              "3", // អាចជំនួសដោយ៖ ${ctr.saleItems.length}
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
                    
                    // អត្ថបទបង្ហាញព័ត៌មានកុម្ម៉ង់បច្ចុប្បន្ន
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
                          "3 Items", // អាចជំនួសដោយចំនួនប្រែប្រួលតាមជាក់ស្តែង
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    
                    // ផ្នែកបង្ហាញតម្លៃសរុបទឹកប្រាក់ និងប៊ូតុងព្រួញទៅមុខ
                    const Text(
                      "\$45.00", // អាចជំនួសដោយ៖ \$${ctr.totalAmount}
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