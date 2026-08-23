import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_project/models/report/report_detail_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SalesTransactionModel>> getSalesData(String filter) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('sale').get();

      // print("[Debug] Total Documents fetched from Firestore: ${snapshot.docs.length}");

      List<SalesTransactionModel> list = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        DateTime? docDate = _extractDateTime(data['sale_date']) ??
            _extractDateTime(data['saledate']) ??
            _extractDateTime(data['createdAt']) ??
            _extractDateTime(data['created_at']) ??
            _extractDateTime(data['date']) ??
            _extractDateTime(data['timestamp']);

        // print("Doc ID: ${doc.id} | Parsed Date: $docDate | Keys: ${data.keys.toList()}");

        // Filter តាម Date Range
        if (_isDateInFilter(docDate, filter)) {
          list.add(SalesTransactionModel.fromFirestore(doc.id, data));
        }
      }

      print("[Debug] Total items passed filter ('$filter'): ${list.length}");

      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    } catch (e) {
      print("Error fetching sales data: $e");
      return [];
    }
  }

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

  bool _isDateInFilter(DateTime? date, String filter) {
    if (filter == 'All') return true;

    if (date == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (filter == 'Today') {
      return checkDate.isAtSameMomentAs(today);
    } else if (filter == 'This Week') {
      final monday = today.subtract(Duration(days: now.weekday - 1));
      final sunday = monday.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
      
      return (date.isAfter(monday.subtract(const Duration(seconds: 1))) &&
          date.isBefore(sunday));
    } else if (filter == 'This Month') {
      return date.year == now.year && date.month == now.month;
    } else if (filter == 'This Year') {
      return date.year == now.year;
    }
    return true;
  }
}