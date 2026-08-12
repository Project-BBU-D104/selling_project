import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_project/models/report/report_detail_model.dart';
import 'package:selling_project/models/report/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Fetch Sales Data ជាមួយ Safety Date Parsing & Dynamic Filtering
  Future<List<SalesTransactionModel>> getSalesData(String filter) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('sales').get();

      List<SalesTransactionModel> list = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Safe Date Extractor: ឆែកមើលគ្រប់ Field ឈ្មោះ Date ឬ CreatedAt (Timestamp / String / dynamic)
        DateTime? docDate = _extractDateTime(data['createdAt']) ??
            _extractDateTime(data['date']) ??
            _extractDateTime(data['salesDate']) ??
            _extractDateTime(data['created_at']);

        // ប្រសិនបើគ្មាន Date សោះ ប្រើ DateTime.now() ជា Fallback
        docDate ??= DateTime.now();

        // Filter តាម Date Range ដែលបានជ្រើសរើស
        if (_isDateInFilter(docDate, filter)) {
          list.add(SalesTransactionModel.fromFirestore(doc.id, data));
        }
      }

      // រៀបតាមកាលបរិច្ឆេទថ្មីទៅចាស់ (Descending)
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    } catch (e) {
      print("Error fetching sales data: $e");
      return [];
    }
  }

  // 2. Fetch Summary Report ដោយផ្ទាល់ (សម្រាប់ Default Fetching)
  Future<ReportSummaryModel> getSalesReportSummary() async {
    try {
      List<SalesTransactionModel> allSales = await getSalesData('This Month');

      double totalSales = 0.0;
      double totalProfit = 0.0;
      int totalProducts = 0;

      for (var item in allSales) {
        totalSales += item.grandTotal;
        totalProfit += item.profit;
        totalProducts += item.totalQty;
      }

      return ReportSummaryModel(
        totalSales: totalSales,
        netProfit: totalProfit,
        totalOrders: allSales.length,
        totalProductsSold: totalProducts,
      );
    } catch (e) {
      print("Error getting summary: $e");
      return ReportSummaryModel(
        totalSales: 0.0,
        netProfit: 0.0,
        totalOrders: 0,
        totalProductsSold: 0,
      );
    }
  }

  // Helper សម្រាប់ទាញយក DateTime សុវត្ថិភាពពី Firestore Field
  DateTime? _extractDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value);
    } else if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }

  // Helper សម្រាប់ Filter Date
  bool _isDateInFilter(DateTime date, String filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (filter == 'Today') {
      return checkDate.isAtSameMomentAs(today);
    } else if (filter == 'This Week') {
      // គណនាថ្ងៃដើមសប្តាហ៍ (Monday)
      final mondayOfThisWeek = today.subtract(Duration(days: now.weekday - 1));
      final sundayOfThisWeek = mondayOfThisWeek.add(const Duration(days: 6));
      
      return (checkDate.isAfter(mondayOfThisWeek.subtract(const Duration(days: 1))) &&
          checkDate.isBefore(sundayOfThisWeek.add(const Duration(days: 1))));
    } else if (filter == 'This Month') {
      return date.year == now.year && date.month == now.month;
    } else if (filter == 'This Year') {
      return date.year == now.year;
    }
    return true;
  }
}