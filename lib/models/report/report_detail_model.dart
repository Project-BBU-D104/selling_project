import 'package:cloud_firestore/cloud_firestore.dart';

class SalesTransactionModel {
  final String id;
  final String invoiceNo;
  final double grandTotal;
  final double profit;
  final int totalQty;
  final DateTime date;

  SalesTransactionModel({
    required this.id,
    required this.invoiceNo,
    required this.grandTotal,
    required this.profit,
    required this.totalQty,
    required this.date,
  });

  factory SalesTransactionModel.fromFirestore(String id, Map<String, dynamic> data) {
    double calculatedTotal = 0.0;
    double calculatedProfit = 0.0;
    int calculatedQty = 0;

    // 1. Loop គណនា Qty, Total, និង Profit ចេញពី Items Array ក្នុង document
    if (data['items'] != null && data['items'] is List) {
      final List itemsList = data['items'];
      for (var item in itemsList) {
        if (item is Map) {
          int qty = ((item['qty'] ?? item['quantity'] ?? 1) as num).toInt();
          
          // តម្លៃលក់ (Selling Price)
          double price = ((item['price'] ?? item['selling_price'] ?? item['unit_price'] ?? 0) as num).toDouble();
          
          // តម្លៃដើម (Cost Price / Capital)
          double cost = ((item['cost_price'] ?? item['cost'] ?? item['buy_price'] ?? 0) as num).toDouble();

          calculatedQty += qty;
          calculatedTotal += (price * qty);
          
          // Profit = (តម្លៃលក់ - តម្លៃដើម) * ចំនួនលក់
          calculatedProfit += ((price - cost) * qty);
        }
      }
    }

    // ដក Discount (បើមាន)
    double discount = ((data['discount'] ?? 0) as num).toDouble();
    calculatedProfit = calculatedProfit - discount;

    // 2. ជ្រើសរើស Value (ប្រើពី Firestore បើមាន ស្របពេល Fallback ទៅតម្លៃគណនា)
    double finalGrandTotal = ((data['grandTotal'] ?? data['grand_total'] ?? data['total_amount'] ?? calculatedTotal) as num).toDouble();
    
    double finalProfit = data['profit'] != null 
        ? ((data['profit']) as num).toDouble() 
        : (data['net_profit'] != null ? ((data['net_profit']) as num).toDouble() : calculatedProfit);

    int finalQty = ((data['totalQty'] ?? data['total_qty'] ?? calculatedQty) as num).toInt();

    // 3. Date Parser
    DateTime dateVal = DateTime.now();
    dynamic rawDate = data['sale_date'] ?? data['createdAt'] ?? data['created_at'] ?? data['date'];
    if (rawDate is Timestamp) {
      dateVal = rawDate.toDate();
    } else if (rawDate is String) {
      dateVal = DateTime.tryParse(rawDate) ?? DateTime.now();
    }

    return SalesTransactionModel(
      id: id,
      invoiceNo: data['invoice_no'] ?? data['invoiceNo'] ?? (id.length > 6 ? id.substring(0, 6).toUpperCase() : id),
      grandTotal: finalGrandTotal,
      profit: finalProfit < 0 ? 0.0 : finalProfit, // ការពារតម្លៃអវិជ្ជមាន
      totalQty: finalQty,
      date: dateVal,
    );
  }
}