class PurchaseItemsModel {
  String? id;
  String? purchaseId;
  String productId;
  String? productName;
  int quantity;
  double unitPrice;
  double totalPrice;

  PurchaseItemsModel({
    this.id,
    this.purchaseId,
    required this.productId,
    this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory PurchaseItemsModel.fromJson(Map<String, dynamic> json, String id) {
    return PurchaseItemsModel(
      id: id,
      purchaseId: json["purchase_id"] ?? "",
      productId: json["product_id"] ?? "",
      productName: json["product_name"] ?? "",
      quantity: (json["quantity"] as num?)?.toInt() ?? 0,
      unitPrice: (json["cost_price"] ?? json["unit_price"] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json["total_price"] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (purchaseId != null) "purchase_id": purchaseId,
      "product_id": productId,
      "product_name": productName,
      "quantity": quantity,
      "cost_price": unitPrice,
      "unit_price": unitPrice,
      "total_price": totalPrice,
    };
  }
}