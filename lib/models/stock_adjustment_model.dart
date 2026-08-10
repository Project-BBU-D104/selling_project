class StockAdjustmentModel {
  final String? id;
  final String productId;
  final String? productName;
  final String adjustmentType;
  final int quantity;
  final String? reason;
  final String? userId;
  final String? userName;
  final DateTime? adjustmentDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  StockAdjustmentModel({
    this.id,
    required this.productId,
    this.productName,
    required this.adjustmentType,
    required this.quantity,
    this.reason,
    this.userId,
    this.userName,
    this.adjustmentDate,
    this.createdAt,
    this.updatedAt,
  });

  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) {
    return StockAdjustmentModel(
      id: json['id']?.toString(),
      productId: json['product_id']?.toString() ?? json['productId']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? json['productName']?.toString(),

      
      adjustmentType: json['adjustment_type']?.toString() ?? json['adjustmentType']?.toString() ?? '',
      quantity: json['quantity'] is int 
          ? json['quantity'] 
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
          
      reason: json['reason']?.toString(),
      userId: json['user_id']?.toString() ?? json['userId']?.toString(),
      userName: json['user_name']?.toString() ?? json['userName']?.toString(),
      
      adjustmentDate: json['adjustment_date'] != null
          ? DateTime.tryParse(json['adjustment_date'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'product_id': productId,
      'adjustment_type': adjustmentType,
      'quantity': quantity,
      'reason': reason,
      'user_id': userId,
      'user_name': userName,
      'adjustment_date': adjustmentDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}