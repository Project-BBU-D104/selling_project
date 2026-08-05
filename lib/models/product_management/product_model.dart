import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String productName;
  String? brandId;
  String? supplierId;
  double costPrice;
  double salePrice;
  int quantity;
  String? image;
  String? description;
  bool status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductModel({
    this.id,
    required this.productName,
    this.brandId,
    this.supplierId,
    required this.costPrice,
    required this.salePrice,
    this.quantity = 0,
    this.image,
    this.description,
    this.status = true,
    this.createdAt,
    this.updatedAt,
  });

  String get name => productName;
  double get price => salePrice;
  String? get imageUrl => image;

  ProductModel copyWith({
    String? id,
    String? productName,
    String? brandId,
    String? supplierId,
    double? costPrice,
    double? salePrice,
    int? quantity,
    String? image,
    String? description,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      brandId: brandId ?? this.brandId,
      supplierId: supplierId ?? this.supplierId,
      costPrice: costPrice ?? this.costPrice,
      salePrice: salePrice ?? this.salePrice,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
    String? id,
  ) {
    return ProductModel(
      id: id ?? json['id']?.toString(),
      productName: json['product_name'] ?? json['name'] ?? '',
      brandId: json['brand_id']?.toString(),
      supplierId: json['supplier_id']?.toString(),
      costPrice: (json['cost_price'] ?? 0).toDouble(),
      salePrice: (json['sale_price'] ?? 0).toDouble(),
      quantity: (json['quantity'] ?? 0) is int 
          ? json['quantity'] 
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      image: json['image'] ?? json['image_url'],
      description: json['description'],
      status: json['status'] ?? true,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "product_name": productName,
      "brand_id": brandId,
      "supplier_id": supplierId,
      "cost_price": costPrice,
      "sale_price": salePrice,
      "quantity": quantity,
      "image": image,
      "description": description,
      "status": status,
      "created_at": createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}