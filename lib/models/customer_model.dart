import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? id;
  String customerName;
  String phone;
  String email;
  String? address;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? category;
  double? totalPurchases;
  double? balance;

  CustomerModel({
    this.id,
    required this.customerName,
    required this.phone,
    required this.email,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.totalPurchases,
    this.balance,
  });

  factory CustomerModel.fromJson(
    Map<String, dynamic> json,
    String? id,
  ) {
    return CustomerModel(
      id: id,
      customerName: json['customer_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? false,
      createdAt: json['created_at'] is Timestamp 
          ? (json['created_at'] as Timestamp).toDate() 
          : null,
      updatedAt: json['updated_at'] is Timestamp 
          ? (json['updated_at'] as Timestamp).toDate() 
          : null,
      category: json['category'] ?? 'Standard',
      totalPurchases: json['total_purchases'] != null 
          ? (json['total_purchases'] as num).toDouble() 
          : 0.0,
      balance: json['balance'] != null 
          ? (json['balance'] as num).toDouble() 
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customer_name": customerName,
      "phone": phone,
      "email": email,
      "address": address,
      "status": status,
      "created_at": createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      "updated_at": updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
      "category": category ?? 'Standard',
      "total_purchases": totalPurchases ?? 0.0,
      "balance": balance ?? 0.0,
    };
  }
}