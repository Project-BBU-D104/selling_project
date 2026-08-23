import 'package:get/get.dart';
import 'package:selling_project/models/dashboard/dashboard_kpi_model.dart';
import 'package:selling_project/services/dashboard_service.dart';

class DashboardController extends GetxController {
  final DashboardService _service = DashboardService();

  var isLoading = true.obs;
  var isTopProductsLoading = false.obs;
  var selectedFilter = 'Month'.obs;

  // Rx Variables សម្រាប់កាន់ Data
  var kpiData = Rxn<DashboardKpiModel>();
  var monthlyRevenue = <double>[].obs;
  var topProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllDashboardData();
  }

  // 🔹 Fetch Data ទាំងអស់ក្នុងពេលតែមួយ
  Future<void> fetchAllDashboardData() async {
    try {
      isLoading(true);

      // Call Parallel Async Calls
      final results = await Future.wait([
        _service.fetchDashboardKpi(),
        _service.fetchMonthlyRevenueChart(year: DateTime.now().year),
        _service.fetchTopSellingProducts(filter: selectedFilter.value),
      ]);

      // 1. Assign KPI Data
      if (results[0] is DashboardKpiModel) {
        kpiData.value = results[0] as DashboardKpiModel;
      }

      // 2. Safely parse Monthly Revenue
      if (results[1] is List) {
        final revenueList = (results[1] as List)
            .map((e) => double.tryParse(e.toString()) ?? 0.0)
            .toList();
        monthlyRevenue.assignAll(revenueList);
      }

      // 3. Safely parse Top Products
      if (results[2] is List) {
        final productsList = (results[2] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        topProducts.assignAll(productsList);
      }
    } catch (e) {
      Get.snackbar(
        'Error Loading Dashboard',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // 🔹 ពេលអ្នកប្រើប្រាស់ចុចដូរ Filter (Week / Month / Year)
  Future<void> changeFilter(String filter) async {
    if (selectedFilter.value == filter && topProducts.isNotEmpty) return;

    try {
      selectedFilter.value = filter;
      isTopProductsLoading(true);

      final result = await _service.fetchTopSellingProducts(filter: filter);
      
      final productsList = result
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
          
      topProducts.assignAll(productsList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to filter top products: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isTopProductsLoading(false);
    }
  }

  // 🔹 Helper សម្រាប់ Refresh Data ឡើងវិញ (ឧទាហរណ៍៖ Pull to Refresh)
  Future<void> refreshDashboard() async {
    await fetchAllDashboardData();
  }
}