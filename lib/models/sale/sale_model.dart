import 'package:cloud_firestore/cloud_firestore.dart';
import 'sale_items_model.dart';

class SaleModel {
  String? id;
  String invoiceNo;
  String? customerId;
  String? customerName;
  String userId;
  double subtotal;
  double tax;
  double discount;
  double totalAmount;
  String paymentStatus;
  String? paymentMethod;
  DateTime saleDate;
  List<SaleItemModel>? items;

  SaleModel({
    this.id,
    required this.invoiceNo,
    this.customerId,
    this.customerName,
    required this.userId,
    required this.subtotal,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.totalAmount,
    required this.paymentStatus,
    this.paymentMethod,
    required this.saleDate,
    this.items,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json, String id) {
    return SaleModel(
      id: id,
      invoiceNo: json['invoice_no'] ?? '',
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      userId: json['user_id'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paymentStatus: json['payment_status'] ?? '',
      paymentMethod: json['payment_method'],
      saleDate: json['sale_date'] is Timestamp
          ? (json['sale_date'] as Timestamp).toDate()
          : (json['sale_date'] is String
              ? DateTime.tryParse(json['sale_date']) ?? DateTime.now()
              : DateTime.now()),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => SaleItemModel.fromJson(item, item['id'] ?? ''))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "invoice_no": invoiceNo,
      "customer_id": customerId,
      "customer_name": customerName,
      "user_id": userId,
      "subtotal": subtotal,
      "tax": tax,
      "discount": discount,
      "total_amount": totalAmount,
      "payment_status": paymentStatus,
      "payment_method": paymentMethod,
      "sale_date": saleDate,
      "items": items?.map((item) => item.toJson()).toList(),
    };
  }
}