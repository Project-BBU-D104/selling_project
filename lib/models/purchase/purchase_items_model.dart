class PurchaseItemsModel {
  String? id;
  String purchaseId;
  String productId;
  int quantity;
  double unitPrice;
  double totalPrice;
  
  PurchaseItemsModel({
    this.id,
    required this.purchaseId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice
  });

  factory PurchaseItemsModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return PurchaseItemsModel(
      id: id,
      purchaseId: json["purchase_id"] ?? "",
      productId: json["product_id"] ?? "",
      quantity: json["quantity"] ?? 0,
      unitPrice: json["unit_price"] ?? 0.0,
      totalPrice: json["total_price"] ?? 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "purchase_id": purchaseId,
      "product_id": productId,
      "quantity": quantity,
      "unit_price": unitPrice,
      "total_price": totalPrice
    };
  }
}