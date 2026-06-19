class SaleItemModel {
  String? id;
  String productId;
  String productName;
  String categoryId;
  String categoryName;
  int quantity;
  double unitPrice;
  double totalPrice;

  SaleItemModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory SaleItemModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return SaleItemModel(
      id: id,
      productId: json["product_id"] ?? "",
      productName: json["product_name"] ?? "",
      categoryId: json["category_id"] ?? "",
      categoryName: json["category_name"] ?? "",
      quantity: json["quantity"] ?? 0,
      unitPrice: (json["unit_price"] ?? 0).toDouble(),
      totalPrice: (json["total_price"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "product_name": productName,
      "category_id": categoryId,
      "category_name": categoryName,
      "quantity": quantity,
      "unit_price": unitPrice,
      "total_price": totalPrice,
    };
  }
}