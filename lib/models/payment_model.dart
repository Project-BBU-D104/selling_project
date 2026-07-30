class PaymentModel {
  String? id;
  String saleId;
  String? invoiceNo;
  String? customerName;
  String paymentMethod;
  double amount;
  String? referenceNo;
  String? note;
  String status;
  DateTime paymentDate;

  PaymentModel({
    this.id,
    required this.saleId,
    this.invoiceNo,
    this.customerName,
    required this.paymentMethod,
    required this.amount,
    this.referenceNo,
    this.note,
    this.status = 'Paid',
    required this.paymentDate,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json, String? id) {
    return PaymentModel(
      id: id ?? json['id'],
      saleId: json['sale_id'] ?? '',
      invoiceNo: json['invoice_no'] ?? '#INV-2023-001',
      customerName: json['customer_name'] ?? '',
      paymentMethod: json['payment_method'] ?? 'Cash Riel',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      referenceNo: json['reference_no'] ?? '',
      note: json['note'] ?? '',
      status: json['status'] ?? 'Paid',
      paymentDate: json['payment_date'] != null
          ? (json['payment_date'] is String
              ? DateTime.parse(json['payment_date'])
              : json['payment_date'].toDate())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sale_id": saleId,
      "payment_method": paymentMethod,
      "amount": amount,
      "reference_no": referenceNo,
      "note": note,
      "status": status,
      "payment_date": paymentDate.toIso8601String(),
    };
  }
}