class PurchaseModel {
  String? id;
  String supplierId;
  String? supplierName;
  String userId;
  String invoiceNo;
  double totalAmount;
  DateTime purchaseDate;
  DateTime? expectedDelivery;
  String status; // 'Received', 'In Transit', 'Completed', 'Cancelled', 'Pending'

  PurchaseModel({
    this.id,
    required this.supplierId,
    this.supplierName,
    this.userId = 'USER_001',
    required this.invoiceNo,
    required this.totalAmount,
    required this.purchaseDate,
    this.expectedDelivery,
    this.status = 'Pending',
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json, String? id) {
    return PurchaseModel(
      id: id ?? json['id'],
      supplierId: json['supplier_id'] ?? '',
      supplierName: json['supplier_name'] ?? 'Global Hardware Inc.',
      userId: json['user_id'] ?? '',
      invoiceNo: json['invoice_no'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      purchaseDate: json['purchase_date'] != null
          ? (json['purchase_date'] is String
              ? DateTime.parse(json['purchase_date'])
              : json['purchase_date'].toDate())
          : DateTime.now(),
      expectedDelivery: json['expected_delivery'] != null
          ? (json['expected_delivery'] is String
              ? DateTime.parse(json['expected_delivery'])
              : json['expected_delivery'].toDate())
          : null,
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "supplier_id": supplierId,
      "supplier_name": supplierName,
      "user_id": userId,
      "invoice_no": invoiceNo,
      "total_amount": totalAmount,
      "purchase_date": purchaseDate.toIso8601String(),
      "expected_delivery": expectedDelivery?.toIso8601String(),
      "status": status,
    };
  }
}