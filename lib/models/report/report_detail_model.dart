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
    return SalesTransactionModel(
      id: id,
      invoiceNo: data['invoice_no'] ?? data['invoiceNo'] ?? id.substring(0, 6).toUpperCase(),
      grandTotal: ((data['grandTotal'] ?? data['total_amount'] ?? 0) as num).toDouble(),
      profit: ((data['profit'] ?? 0) as num).toDouble(),
      totalQty: ((data['totalQty'] ?? data['total_qty'] ?? 0) as num).toInt(),
      date: data['createdAt'] != null 
          ? (data['createdAt'] as dynamic).toDate() 
          : DateTime.now(),
    );
  }
}

class TopProductReportModel {
  final String name;
  final int qtySold;
  final double totalRevenue;

  TopProductReportModel({
    required this.name,
    required this.qtySold,
    required this.totalRevenue,
  });
}