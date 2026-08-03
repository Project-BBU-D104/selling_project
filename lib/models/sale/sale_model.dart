import 'package:cloud_firestore/cloud_firestore.dart';

// 🔹 Model សម្រាប់ទំនិញនីមួយៗក្នុង Order
class OrderItemModel {
  String? productId;
  String? productName;
  double price;
  int quantity;

  OrderItemModel({
    this.productId,
    this.productName,
    required this.price,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'],
      productName: json['product_name'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
    };
  }
}

// 🔹 Model សម្រាប់ Sale
class SaleModel {
  String? id;
  String invoiceNo;
  String? customerId;
  String? customerName;
  String userId;
  double subtotal;
  double discount;
  double tax;
  double totalAmount;
  String paymentStatus;
  String paymentMethod;
  DateTime saleDate;
  List<OrderItemModel> items; // <--- បន្ថែម Field items ត្រង់នេះ

  SaleModel({
    this.id,
    required this.invoiceNo,
    this.customerId,
    this.customerName,
    required this.userId,
    required this.subtotal,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
    required this.paymentStatus,
    this.paymentMethod = 'Cash',
    required this.saleDate,
    required this.items, // <--- បន្ថែមក្នុង Constructor
  });

  factory SaleModel.fromJson(Map<String, dynamic> json, String id) {
    return SaleModel(
      id: id,
      invoiceNo: json['invoice_no'] ?? '',
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      userId: json['user_id'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paymentStatus: json['payment_status'] ?? '',
      paymentMethod: json['payment_method'] ?? 'Cash',
      saleDate: json['sale_date'] is Timestamp
          ? (json['sale_date'] as Timestamp).toDate()
          : DateTime.tryParse(json['sale_date'].toString()) ?? DateTime.now(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItemModel.fromJson(Map<String, dynamic>.from(item)))
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
      "discount": discount,
      "tax": tax,
      "total_amount": totalAmount,
      "payment_status": paymentStatus,
      "payment_method": paymentMethod,
      "sale_date": Timestamp.fromDate(saleDate),
      "items": items.map((item) => item.toJson()).toList(),
    };
  }
}