import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_project/models/dashboard/dashboard_kpi_model.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const int kDefaultLowStockThreshold = 5;

  //Fetch KPI Metrics Data
  Future<DashboardKpiModel> fetchDashboardKpi() async {
    try {
      final GetOptions options = Platform.isWindows 
          ? const GetOptions(source: Source.serverAndCache) 
          : const GetOptions();

      //Total Active Products
      final productsSnap = await _firestore.collection('products').get(options);
      final activeProducts = productsSnap.docs.where((doc) {
        final data = doc.data();
        return data['is_deleted'] != true;
      }).toList();

      final totalProducts = activeProducts.length;

      //Total Sales
      final salesSnap = await _firestore.collection('sale').get(options);
      double totalSales = 0.0;
      for (var doc in salesSnap.docs) {
        final data = doc.data();
        final num amount = data['subtotal'] ?? data['total_amount'] ?? data['grand_total'] ?? 0;
        totalSales += amount.toDouble();
      }

      //Total Purchases
      final purchasesSnap = await _firestore.collection('purchases').get(options);
      double totalPurchases = 0.0;
      for (var doc in purchasesSnap.docs) {
        final data = doc.data();
        final num amount = data['total_amount'] ?? data['grand_total'] ?? data['subtotal'] ?? 0;
        totalPurchases += amount.toDouble();
      }

      //Total Customers Count
      int totalCustomers = 0;
      if (Platform.isWindows) {
        final customersSnap = await _firestore.collection('customers').get(options);
        totalCustomers = customersSnap.docs.length;
      } else {
        final customersSnap = await _firestore.collection('customers').count().get();
        totalCustomers = customersSnap.count ?? 0;
      }

      //Total Suppliers Count
      int totalSuppliers = 0;
      if (Platform.isWindows) {
        final suppliersSnap = await _firestore.collection('suppliers').get(options);
        totalSuppliers = suppliersSnap.docs.length;
      } else {
        final suppliersSnap = await _firestore.collection('suppliers').count().get();
        totalSuppliers = suppliersSnap.count ?? 0;
      }

      //Low Stock Alerts
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
      return DashboardKpiModel(
        totalProducts: 0,
        totalSales: 0.0,
        totalPurchases: 0.0,
        totalCustomers: 0,
        totalSuppliers: 0,
        lowStockAlerts: 0,
      );
    }
  }

  //Fetch Monthly Revenue Chart
  Future<List<double>> fetchMonthlyRevenueChart({required int year}) async {
    try {
      final GetOptions options = Platform.isWindows 
          ? const GetOptions(source: Source.serverAndCache) 
          : const GetOptions();

      final salesSnap = await _firestore.collection('sale').get(options);
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

  //Fetch Top Selling Products (Filtered by Week, Month, Year)
  Future<List<Map<String, dynamic>>> fetchTopSellingProducts({required String filter}) async {
    try {
      final GetOptions options = Platform.isWindows 
          ? const GetOptions(source: Source.serverAndCache) 
          : const GetOptions();

      final salesSnap = await _firestore.collection('sale').get(options);

      if (salesSnap.docs.isEmpty) {
        return [];
      }

      Map<String, Map<String, dynamic>> productSummary = {};
      final DateTime now = DateTime.now();

      for (var saleDoc in salesSnap.docs) {
        final saleData = saleDoc.data();
        final dynamic rawDate = saleData['sale_date'] ?? saleData['created_at'];

        DateTime? saleDate;
        if (rawDate is Timestamp) {
          saleDate = rawDate.toDate();
        } else if (rawDate is String) {
          saleDate = DateTime.tryParse(rawDate);
        }
        if (saleDate != null) {
          if (!_isDateMatchFilter(saleDate, now, filter)) {
            continue;
          }
        }

        final String saleDateStr = saleDate != null 
            ? saleDate.toIso8601String().split('T').first 
            : 'N/A';

        final List dynamicItems = saleData['items'] ?? [];
        if (dynamicItems.isNotEmpty) {
          for (var item in dynamicItems) {
            final String productName = item['product_name'] ?? item['name'] ?? 'Unknown';
            final int qty = (item['quantity'] ?? item['qty'] ?? 1) as int;
            final double totalPrice = (item['total_price'] ?? item['total'] ?? (qty * (item['unit_price'] ?? item['price'] ?? 0))).toDouble();

            _aggregateProduct(productSummary, productName, qty, totalPrice, saleDateStr);
          }
        } else {
          final itemsSnap = await saleDoc.reference.collection('sale_items').get(options);
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

  bool _isDateMatchFilter(DateTime saleDate, DateTime now, String filter) {
    final String cleanFilter = filter.trim().toLowerCase();

    if (cleanFilter == 'week') {
      final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final DateTime beginningOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      return saleDate.isAfter(beginningOfWeek) || saleDate.isAtSameMomentAs(beginningOfWeek);
    } else if (cleanFilter == 'month') {
      return saleDate.year == now.year && saleDate.month == now.month;
    } else if (cleanFilter == 'year') {
      return saleDate.year == now.year;
    }

    return true;
  }

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