import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  String? id;
  String name;
  String? contactPerson;
  String phone;
  String email;
  String? companyName;
  bool status;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;

  SupplierModel({ 
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address = '',
    this.contactPerson = '',
    this.companyName = '',
    this.status = true,
    this.createdAt,
    this.updatedAt
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json, String? id) {
    return SupplierModel(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      companyName: json['company_name'] ?? '',
      status: json['status'] ?? true,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "contact_person": contactPerson,
      "company_name": companyName,
      "status": status,
      "created_at": createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      "updated_at": updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    if (value is Timestamp) {
      return value.toDate();
    }
    
    if (value is String) {
      return DateTime.tryParse(value);
    }
    
    return null;
  }
}