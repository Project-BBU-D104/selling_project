import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selling_project/controller/dashboard_controller.dart';
import 'package:selling_project/screen/dashboard/widget/kpi_card_widget.dart';
import 'package:selling_project/screen/dashboard/widget/sales_bar_chart_widget.dart';
import 'package:selling_project/screen/dashboard/widget/top_selling_widget.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final kpi = controller.kpiData.value;
        if (kpi == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No Data Available'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.fetchAllDashboardData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchAllDashboardData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. KPI Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  children: [
                    KpiCardWidget(
                      title: 'Total Products',
                      value: '${kpi.totalProducts}',
                      icon: Icons.inventory_2_outlined,
                      iconColor: const Color(0xFF0284C7),
                      bgColor: const Color(0xFFE0F2FE),
                    ),
                    KpiCardWidget(
                      title: 'Total Sales',
                      value: '\$${kpi.totalSales.toStringAsFixed(0)}',
                      icon: Icons.trending_up_rounded,
                      iconColor: const Color(0xFF16A34A),
                      bgColor: const Color(0xFFDCFCE7),
                    ),
                    KpiCardWidget(
                      title: 'Total Purchases',
                      value: '\$${kpi.totalPurchases.toStringAsFixed(0)}',
                      icon: Icons.shopping_cart_outlined,
                      iconColor: const Color(0xFF6366F1),
                      bgColor: const Color(0xFFEEF2FF),
                    ),
                    KpiCardWidget(
                      title: 'Total Customers',
                      value: '${kpi.totalCustomers}',
                      icon: Icons.people_outline_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      bgColor: const Color(0xFFF3E8FF),
                    ),
                    KpiCardWidget(
                      title: 'Total Suppliers',
                      value: '${kpi.totalSuppliers}',
                      icon: Icons.handshake_outlined,
                      iconColor: const Color(0xFF0D9488),
                      bgColor: const Color(0xFFCCFBF1),
                    ),
                    KpiCardWidget(
                      title: 'Low Stock Alerts',
                      value: '${kpi.lowStockAlerts}',
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFDC2626),
                      bgColor: const Color(0xFFFEE2E2),
                      isAlert: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Bar Chart Section
                const SalesBarChartWidget(),

                const SizedBox(height: 20),

                // 3. Top Selling Section
                const TopSellingWidget(),
              ],
            ),
          ),
        );
      }),
    );
  }
}