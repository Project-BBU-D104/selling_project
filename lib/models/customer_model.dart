import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? id;
  String customerName;
  String? phone;
  String? email;
  String? address;
  bool status;
  DateTime? createdAt;
  DateTime? updatedAt;

  CustomerModel({
    this.id,
    required this.customerName,
    this.phone,
    this.email,
    this.address,
    this.status = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json, String? id) {
    return CustomerModel(
      id: id,
      customerName: json['customer_name'] ?? '',
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      status: json['status'] ?? true,
      createdAt: json['created_at'] is Timestamp 
          ? (json['created_at'] as Timestamp).toDate() 
          : null,
      updatedAt: json['updated_at'] is Timestamp 
          ? (json['updated_at'] as Timestamp).toDate() 
          : null,
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
      "updated_at": FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "customer_name": customerName,
      "phone": phone,
      "email": email,
      "address": address,
      "status": status,
      "updated_at": FieldValue.serverTimestamp(),
    };
  }
}