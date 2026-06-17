class StockAdjustmentModel {
  String? id;
  String name;
  String description;
  Map<String, dynamic> product;
  String adjustmentType;
  int quantity;
  String reason;
  DateTime adjustmentDate = DateTime.now();
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();
   
  StockAdjustmentModel({
    this.id,
    required this.name,
    required this.description,
    required this.product,
    required this.adjustmentType,
    required this.quantity,
    required this.reason,
    required this.adjustmentDate,
    this.createdAt,
    this.updatedAt

  });

  factory StockAdjustmentModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return StockAdjustmentModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      product: json['product'] ?? {},
      adjustmentType: json['adjustment_type'] ?? '',
      quantity: json['quantity'] ?? 0,
      reason: json['reason'] ?? '',
      adjustmentDate: json['adjustment_date'] ?? DateTime.now(),
      createdAt: json['created_at'] ?? DateTime.now(),
      updatedAt: json['updated_at'] ?? DateTime.now(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "description": description,
      "product": product,
      "adjustment_type": adjustmentType,
      "quantity": quantity,
      "reason": reason,
      "adjustment_date": adjustmentDate,
      "created_at": createdAt,
      "updated_at": updatedAt
    };
  }
}