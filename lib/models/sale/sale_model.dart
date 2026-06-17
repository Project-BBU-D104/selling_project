import 'package:cloud_firestore/cloud_firestore.dart';

class SaleModel {
  String? id;
  String invoiceNo;
  String? customerId;
  String userId;
  double subtotal;
  double totalAmount;
  String paymentStatus;
  DateTime saleDate;

  SaleModel({
    this.id,
    required this.invoiceNo,
    this.customerId,
    required this.userId,
    required this.subtotal,
    required this.totalAmount,
    required this.paymentStatus,
    required this.saleDate,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json, String id) {
    return SaleModel(
      id: id,
      invoiceNo: json['invoice_no'] ?? '',
      customerId: json['customer_id'],
      userId: json['user_id'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paymentStatus: json['payment_status'] ?? '',
      saleDate: (json['sale_date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "invoice_no": invoiceNo,
      "customer_id": customerId,
      "user_id": userId,
      "subtotal": subtotal,
      "total_amount": totalAmount,
      "payment_status": paymentStatus,
      "sale_date": saleDate,
    };
  }
}