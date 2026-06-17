class SaleItemModel {
  String? id;
  String productId;
  int quantity;
  double unitPrice;
  double totalPrice;

  SaleItemModel({
    this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "quantity": quantity,
      "unit_price": unitPrice,
      "total_price": totalPrice,
    };
  }
}