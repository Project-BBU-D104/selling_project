import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_project/models/dashboard/dashboard_kpi_model.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const int kDefaultLowStockThreshold = 5;

  // 🔹 Fetch KPI Metrics Data
  Future<DashboardKpiModel> fetchDashboardKpi() async {
    try {
      // 1. Total Active Products
      final productsSnap = await _firestore.collection('products').get();
      final activeProducts = productsSnap.docs.where((doc) {
        final data = doc.data();
        return data['is_deleted'] != true;
      }).toList();

      final totalProducts = activeProducts.length;

      // 2. Total Sales (អានពី collection 'sale')
      final salesSnap = await _firestore.collection('sale').get();
      double totalSales = 0.0;
      for (var doc in salesSnap.docs) {
        final data = doc.data();
        final num amount = data['subtotal'] ?? data['total_amount'] ?? data['grand_total'] ?? 0;
        totalSales += amount.toDouble();
      }

      // 3. Total Purchases
      final purchasesSnap = await _firestore.collection('purchases').get();
      double totalPurchases = 0.0;
      for (var doc in purchasesSnap.docs) {
        final data = doc.data();
        final num amount = data['total_amount'] ?? data['grand_total'] ?? data['subtotal'] ?? 0;
        totalPurchases += amount.toDouble();
      }

      // 4. Total Customers Count
      final customersSnap = await _firestore.collection('customers').count().get();
      final totalCustomers = customersSnap.count ?? 0;

      // 5. Total Suppliers Count
      final suppliersSnap = await _firestore.collection('suppliers').count().get();
      final totalSuppliers = suppliersSnap.count ?? 0;

      // 6. Low Stock Alerts
      int lowStockAlerts = 0;
      for (var doc in activeProducts) {
        final data = doc.data();
        final num qty = data['stock_quantity'] ?? data['qty'] ?? data['quantity'] ?? 0;
        final num alertThreshold = data['min_quantity'] ?? kDefaultLowStockThreshold;

        if (qty <= alertThreshold) {
          lowStockAlerts++;
        }
      }

      return DashboardKpiModel(
        totalProducts: totalProducts,
        totalSales: totalSales,
        totalPurchases: totalPurchases,
        totalCustomers: totalCustomers,
        totalSuppliers: totalSuppliers,
        lowStockAlerts: lowStockAlerts,
      );
    } catch (e) {
      print("Error in fetchDashboardKpi: $e");
      throw Exception('Failed to load Firestore KPI data: $e');
    }
  }

  // 🔹 Fetch Monthly Revenue Chart
  Future<List<double>> fetchMonthlyRevenueChart({required int year}) async {
    try {
      final salesSnap = await _firestore.collection('sale').get();
      List<double> monthlyTotals = List.filled(12, 0.0);

      for (var doc in salesSnap.docs) {
        final data = doc.data();
        final dynamic rawDate = data['sale_date'] ?? data['created_at'];
        final num amount = data['subtotal'] ?? data['total_amount'] ?? 0;

        DateTime? saleDate;
        if (rawDate is Timestamp) {
          saleDate = rawDate.toDate();
        } else if (rawDate is String) {
          saleDate = DateTime.tryParse(rawDate);
        }

        if (saleDate != null && saleDate.year == year) {
          int monthIndex = saleDate.month - 1;
          monthlyTotals[monthIndex] += amount.toDouble();
        }
      }

      return monthlyTotals;
    } catch (e) {
      print("Error in fetchMonthlyRevenueChart: $e");
      return List.filled(12, 0.0);
    }
  }

  // 🔹 Fetch Top Selling Products (អាន Subcollection 'sale_items' និង Array 'items')
  Future<List<Map<String, dynamic>>> fetchTopSellingProducts({required String filter}) async {
    try {
      final salesSnap = await _firestore.collection('sale').get();

      if (salesSnap.docs.isEmpty) {
        return [];
      }

      Map<String, Map<String, dynamic>> productSummary = {};

      for (var saleDoc in salesSnap.docs) {
        final saleData = saleDoc.data();
        final String saleDateStr = (saleData['sale_date'] is Timestamp)
            ? (saleData['sale_date'] as Timestamp).toDate().toIso8601String().split('T').first
            : (saleData['sale_date']?.toString() ?? 'N/A');

        // ១. ពិនិត្យមើល Array Field 'items' ជាមុនសិន
        final List dynamicItems = saleData['items'] ?? [];
        if (dynamicItems.isNotEmpty) {
          for (var item in dynamicItems) {
            final String productName = item['product_name'] ?? item['name'] ?? 'Unknown';
            final int qty = (item['quantity'] ?? item['qty'] ?? 1) as int;
            final double totalPrice = (item['total_price'] ?? item['total'] ?? (qty * (item['unit_price'] ?? item['price'] ?? 0))).toDouble();

            _aggregateProduct(productSummary, productName, qty, totalPrice, saleDateStr);
          }
        } else {
          // ២. បើគ្មានក្នុង Array ទេ អានចេញពី Subcollection 'sale_items'
          final itemsSnap = await saleDoc.reference.collection('sale_items').get();
          for (var itemDoc in itemsSnap.docs) {
            final item = itemDoc.data();
            final String productName = item['product_name'] ?? 'Unknown';
            final int qty = (item['quantity'] ?? 1) as int;
            final double totalPrice = (item['total_price'] ?? (qty * (item['unit_price'] ?? 0))).toDouble();

            _aggregateProduct(productSummary, productName, qty, totalPrice, saleDateStr);
          }
        }
      }

      List<Map<String, dynamic>> resultList = productSummary.values.toList();
      resultList.sort((a, b) => (b['qty_sold'] as int).compareTo(a['qty_sold'] as int));

      return resultList.take(5).toList();
    } catch (e) {
      print("Error in fetchTopSellingProducts: $e");
      return [];
    }
  }

  // Helper function សម្រាប់បូកសរុបទិន្នន័យ Product
  void _aggregateProduct(
    Map<String, Map<String, dynamic>> summary,
    String productName,
    int qty,
    double totalPrice,
    String saleDateStr,
  ) {
    if (summary.containsKey(productName)) {
      summary[productName]!['qty_sold'] += qty;
      summary[productName]!['revenue'] += totalPrice;
      summary[productName]!['last_sold'] = saleDateStr;
    } else {
      summary[productName] = {
        'product_name': productName,
        'qty_sold': qty,
        'revenue': totalPrice,
        'last_sold': saleDateStr,
      };
    }
  }
}